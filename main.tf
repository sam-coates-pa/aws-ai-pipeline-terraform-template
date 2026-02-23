resource "aws_iam_role" "lambda_role" {
  name = var.lambda_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  tags = {
    Environment = var.env
    AccessLevel = "admin-dev"
  }
}

resource "aws_iam_role_policy_attachment" "lambda_admin_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = var.lambda_exec_role_arn
}

resource "aws_iam_role" "step_function_role" {
  name = var.step_function_role_name

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "states.amazonaws.com"
      }
    }]
  })

  tags = {
    Environment = var.env
    AccessLevel = "admin-dev"
  }
}

resource "aws_iam_role_policy_attachment" "step_function_admin_attach" {
  role       = aws_iam_role.step_function_role.name
  policy_arn = var.lambda_exec_role_arn
}

resource "aws_iam_policy" "step_function_states_policy" {
  name        = "${var.step_function_role_name}-states-policy"
  description = "Explicit states:* permission for dev unblock"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "states:*",
        Resource = "*"
      }
    ]
  })
}