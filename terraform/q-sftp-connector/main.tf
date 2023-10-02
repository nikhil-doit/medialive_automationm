terraform {
  backend "s3" {
    bucket = "terraform-backend-quantilia"
    # NEED TO BE CHANGED
    key = "q-sftp-connector/terraform.tfstate"
    #####################
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock"
  }
}

variable "image_tag" {
  description = "The image id"
  type        = string
}

module "sns" {
  source            = "../module/sns"
  project_name      = "q-sftp-connector"
  environment       = "production"
  aws_region        = "eu-west-1"
  allow_dev         = true
  allow_sftp_server = true
}

module "lambda" {
  source               = "../module/lambda"
  aws_region           = "eu-west-1"
  project_name         = "q-sftp-connector"
  environment          = "production"
  function_name        = "q-sftp-connector"
  function_description = "Handle new file events"
  architectures        = ["arm64"]
  image_name           = "q-sftp-connector"
  image_tag            = var.image_tag
  memory_size          = 128
  timeout              = 3
  concurrent_execution = 10
  vpc                  = "default"
  efs                  = "sftp"
  slack-notification   = true
  invoke-sns-arn       = [module.sns.sns_arn]
}