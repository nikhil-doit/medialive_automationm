/*
terraform {
  backend "s3" {
    bucket = "terraform-backend-quantilia"
    # NEED TO BE CHANGED
    key = "s3-etl/terraform.tfstate"
    #####################
    region         = "eu-west-1"
    dynamodb_table = "terraform-lock"
  }
}
*/

module "s3" {
  source = "./terraform/modules/s3"

  aws_region      = "eu-west-1"
  project_name    = "etl"
  environment     = "production"
  bucket_name     = "etl.quantilia1"
  aws_trusted_arn = [
    "arn:aws:iam::329205314638:user/rdeteix",
    "arn:aws:iam::329205314638:role/lambda-q-sftp-connector",
  ]
  has_versionning = true
}