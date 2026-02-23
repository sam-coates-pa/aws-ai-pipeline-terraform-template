variable "project" {
  type = string
}

variable "env" {
  type = string
}

variable "region" {
  type = string
}

variable "s3_bucket_raw" {
  description = "S3 bucket for raw data ingestion"
  type        = string
}

variable "s3_bucket_processed" {
  description = "S3 bucket for processed data, model output"
  type        = string
}

variable "lifecycle_config_name" {
  type    = string
  default = null
}

variable "glue_script_path" {
  type = string
}

variable "s3_processed_arn" {
  type = string
}

variable "step_function_arn" {
  type = string
}

variable "s3_raw_arn" {
  type = string
}

variable "s3_raw_id" {
  type = string
}