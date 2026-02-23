resource "aws_sfn_state_machine" "pipeline" {
  name       = "${var.project}-${var.env}-fraud-pipeline"
  role_arn   = var.step_function_role_arn
  definition = file("${path.module}/pipeline_definition.json")

  tags = {
    Environment = var.env
    Project     = var.project
  }
}