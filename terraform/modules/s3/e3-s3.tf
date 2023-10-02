resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = {
    project_name = var.project_name
    environment  = var.environment
  }
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.main_bucket_policy.json
}


data "aws_iam_policy_document" "main_bucket_policy" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
    ]

    resources = [
      "${aws_s3_bucket.main.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = var.aws_trusted_arn
    }
  }
}

resource "aws_s3_bucket_versioning" "main" {
  count  = var.has_versionning ? 1 : 0
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}