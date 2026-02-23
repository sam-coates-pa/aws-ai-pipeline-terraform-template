variable "lambda_role_name" {
  description = "Name of the Lambda IAM role"
  type        = string
}

variable "step_function_role_name" {
  description = "Name of the Step Function IAM role"
  type        = string
}

variable "lambda_exec_role_arn" {
  description = "AdministratorAccess policy ARN for dev"
  type        = string
}

variable "env" {
  type = string
}
