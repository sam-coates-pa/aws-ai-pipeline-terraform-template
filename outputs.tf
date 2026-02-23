output "pipeline_arn" {
  value = aws_sfn_state_machine.pipeline.arn
}

output "step_function_role_arn" {
  value = var.step_function_role_arn
}