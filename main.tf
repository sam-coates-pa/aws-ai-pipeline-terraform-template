resource "aws_iam_role" "sagemaker_execution_role" {
  name = "${var.project}-${var.env}-sagemaker-role"
  assume_role_policy = data.aws_iam_policy_document.sagemaker_assume_role.json
}

data "aws_iam_policy_document" "sagemaker_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["sagemaker.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "sagemaker_access_policy" {
  name   = "${var.project}-${var.env}-sagemaker-policy"
  role   = aws_iam_role.sagemaker_execution_role.id
  policy = data.aws_iam_policy_document.sagemaker_access.json
}

data "aws_iam_policy_document" "sagemaker_access" {
  statement {
    actions   = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
    resources = [var.s3_processed_arn, "${var.s3_processed_arn}/*"]
  }
  statement {
    actions   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
    resources = ["arn:aws:logs:*:*:*"]
  }
  statement {
    actions   = ["cloudwatch:PutMetricData"]
    resources = ["*"]
  }
}

resource "aws_sagemaker_notebook_instance" "notebook" {
  name                  = "${var.project}-${var.env}-sagemaker-notebook"
  instance_type         = "ml.t3.medium"
  role_arn              = aws_iam_role.sagemaker_execution_role.arn
  lifecycle_config_name = var.lifecycle_config_name

  tags = {
    Project     = var.project
    Environment = var.env
  }
}