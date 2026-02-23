resource "aws_iam_role" "glue_service_role" {
  name = "${var.project}-${var.env}-glue-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "glue.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_glue_job" "etl_job" {
  name     = "${var.project}-${var.env}-glue-etl"
  role_arn = aws_iam_role.glue_service_role.arn

  command {
    name            = "glueetl"
    script_location = var.glue_script_path
    python_version  = "3"
  }

  glue_version       = "4.0"
  number_of_workers  = 2
  worker_type        = "G.1X"

  execution_property {
    max_concurrent_runs = 1
  }

  tags = {
    Project     = var.project
    Environment = var.env
  }
}
