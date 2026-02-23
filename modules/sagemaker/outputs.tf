output "notebook_instance_name" {
  value = aws_sagemaker_notebook_instance.notebook.name
}

output "sagemaker_execution_role_arn" {
  value = aws_iam_role.sagemaker_execution_role.arn
}
