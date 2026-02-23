variable "project" {
  description = "Project name prefix for resources"
  type = string
}

variable "env" {
  description = "Environment name (e.g. dev, staging, prod)"
  type = string
}

variable "function_name_suffix" {
  description = "Suffix to append to the Lambda function name"
  type = string
}

variable "zip_path" {
  description = "Path to the zipped Lambda deployment package"
  type = string
}

variable "step_function_arn" {
  description = "ARN of the Step Function to invoke"
  type = string
}

variable "lambda_exec_role_arn" {
  description = "ARN of the IAM role that the Lambda function will use"
  type = string
}

variable "s3_raw_arn" {
  description = "ARN of the S3 bucket that triggers the Lambda"
  type = string
  default = null
}

variable "s3_raw_id" {
  description = "ID (name) of the S3 bucket that triggers the Lambda"
  type = string
  default = null
}

variable "s3_processed_arn" {
  description = "ARN of the processed S3 bucket (optional, used if needed)"
  type = string
  default = null
}

variable "s3_processed_id" {
  description = "ID (name) of the processed S3 bucket (optional, used if needed)"
  type = string
  default = null
}