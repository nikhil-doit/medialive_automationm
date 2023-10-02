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


variable "function_name" {
  description = "The function's name"
  type        = string
}

variable "function_description" {
  description = "Function's description"
  type        = string
}

variable "image_name" {
  description = "The tag of the image"
  type        = string
}

variable "image_tag" {
  description = "The tag of the image"
  type        = string
}

variable "architectures" {
  description = "Architectures of the lamdba functions"
  type        = list(string)
  default     = ["arm64"]
}

variable "memory_size" {
  description = "Memory in MB the Lambda Function can use at runtime"
  type        = number
}

variable "timeout" {
  description = "Amount of time the Lambda Function has to run in seconds"
  type        = number
}

variable "concurrent_execution" {
  description = "Amount of reserved concurrent executions for this lambda function"
  type        = number
}

variable "environment_variables" {
  description = "Environment variables."
  type        = map(string)
  default     = null
}

variable "vpc" {
  description = "The vpc in the aws region. eu-west-1 is default"
  type        = string
  default     = null
}

variable "efs" {
  description = "Connect to efs either etl or sftp."
  type        = string
  default     = null
}

variable "rds-pg" {
  description = "Allow to connect to pg."
  type        = bool
  default     = false
}

variable "internet" {
  description = "Allow to connect to internet."
  type        = bool
  default     = false
}

variable "slack-notification" {
  description = "Does the destination should send a notification."
  type        = bool
  default     = false
}

variable "invoke-sns-arn" {
  description = "A list of sns arn that should be invoked."
  type        = list(string)
  default     = []
}