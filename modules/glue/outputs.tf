output "glue_job_name" {
  value = aws_glue_job.etl_job.name
}

output "glue_role_arn" {
  value = aws_iam_role.glue_service_role.arn
}
