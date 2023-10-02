# Input Variables

variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
}

variable "project_name" {
  description = "The project name"
  type        = string
}

variable "environment" {
  description = "The environnement"
  type        = string
}


variable "bucket_name" {
  description = "The function's name"
  type        = string
}


variable "aws_trusted_arn" {
  description = "The trusted aws arn that can get and put"
  type        = list(string)
}

variable "has_versionning" {
  description = "Does the bucket should add versionning"
  type        = bool
  default     = false
}
