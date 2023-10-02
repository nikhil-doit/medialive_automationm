# security group
# lambda
# sqs event mapper
# log

resource "aws_security_group" "main" {
  count       = var.vpc != null ? 1 : 0
  name        = "lambda-${var.function_name}"
  description = "Lambda ${var.function_name} control security group"
  vpc_id      = local.vpc[var.aws_region][var.vpc]["id"]

  tags = {
    Name         = "lambda-${var.function_name}"
    project_name = var.project_name
    environment  = var.environment
  }
}

resource "aws_security_group_rule" "efs-default" {
  count                    = var.vpc != null && var.efs != null ? 1 : 0
  description              = "lambda ${var.function_name} efs etl access"
  security_group_id        = local.vpc[var.aws_region][var.vpc]["sg-default"]
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.main[count.index].id
}

resource "aws_security_group_rule" "rds" {
  count                    = var.vpc != null && var.rds-pg ? 1 : 0
  description              = "lambda ${var.function_name} rds postgres access"
  security_group_id        = local.vpc[var.aws_region][var.vpc]["sg-rds-pg"]
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.main[count.index].id
}

resource "aws_security_group_rule" "internet" {
  count = var.vpc != null && var.internet ? 1 : 0

  description       = "lambda ${var.function_name} internet access"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main[count.index].id
}


# log
data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}


resource "aws_iam_role" "main" {
  name               = "lambda-${var.function_name}"
  assume_role_policy = data.aws_iam_policy_document.main.json
}


resource "aws_iam_role_policy_attachment" "cloudwatch_log" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "invoke-slack-notification" {
  count = var.slack-notification ? 1 : 0

  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::329205314638:policy/invoke-slack-notification"
}

resource "aws_iam_role_policy_attachment" "efs" {
  count = var.vpc != null && var.efs != null ? 1 : 0

  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientReadWriteAccess"
}


resource "aws_iam_role_policy_attachment" "vpc" {
  count = var.vpc != null ? 1 : 0

  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "rds" {
  count      = var.vpc != null && var.rds-pg ? 1 : 0
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
}

resource "aws_iam_role_policy_attachment" "xray" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

resource "aws_cloudwatch_log_group" "main" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "main" {
  function_name = var.function_name
  description   = var.function_description
  package_type  = "Image"
  image_uri     = "329205314638.dkr.ecr.eu-west-1.amazonaws.com/${var.image_name}:${var.image_tag}"
  role          = aws_iam_role.main.arn

  architectures                  = var.architectures
  memory_size                    = var.memory_size
  timeout                        = var.timeout
  reserved_concurrent_executions = var.concurrent_execution


  # efs access point
  dynamic "file_system_config" {
    for_each = (var.efs != null) ? [1] : []
    content {
      local_mount_path = local.efs[var.efs]["efs_local_mount_path"]
      arn              = local.efs[var.efs]["efs_access_point_arn"]
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc != null ? [1] : []
    content {
      # Every subnet should be able to reach an EFS mount target in the same AZ.
      # Cross-AZ mounts are not permitted.
      subnet_ids = [local.vpc[var.aws_region][var.vpc]["subnet-default"]]
      security_group_ids = [
        aws_security_group.main[vpc_config.key].id,
        local.vpc[var.aws_region][var.vpc]["sg-default"]
      ]
    }
  }


  tracing_config {
    mode = "Active"
  }

  environment {
    variables = var.environment_variables
  }

  depends_on = [
    aws_iam_role_policy_attachment.cloudwatch_log,
    aws_iam_role_policy_attachment.xray,
    aws_cloudwatch_log_group.main
  ]

  tags = {
    Name         = var.function_name
    project_name = var.project_name
    environment  = var.environment
  }
}


resource "aws_lambda_function_event_invoke_config" "main" {
  function_name = var.function_name

  maximum_event_age_in_seconds = 60
  maximum_retry_attempts       = 0

  depends_on = [aws_lambda_function.main]

  dynamic "destination_config" {
    for_each = var.slack-notification ? [true] : []
    content {
      on_failure {
        destination = local.slack["arn"]
      }
    }
  }
}

resource "aws_sns_topic_subscription" "main" {
  count     = length(var.invoke-sns-arn)
  protocol  = "lambda"
  topic_arn = var.invoke-sns-arn[count.index]
  endpoint  = aws_lambda_function.main.arn
}

resource "aws_lambda_permission" "main" {
  count         = length(var.invoke-sns-arn)
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = var.invoke-sns-arn[count.index]
}

