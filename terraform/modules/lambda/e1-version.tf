# Terraform Block
terraform {
  required_version = "~> 1.5" # >= 1.3 and < 2.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.16"
    }
  }
}

# Provider Block
provider "aws" {
  region = var.aws_region
}

/*
Note-1:  AWS Credentials Profile (profile = "default")
configured on your local desktop terminal
$HOME/.aws/credentials
*/
