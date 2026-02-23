#main.tf

resource "aws_s3_bucket" "raw_ingest" {
  bucket = "fraud-dev-s3-raw-ingest"
  force_destroy = true
  tags = {
    Environment = var.env
    Project     = var.project
  }
}

resource "aws_s3_bucket" "processed" {
  bucket = "fraud-dev-s3-processed"
  force_destroy = true
  tags = {
    Environment = var.env
    Project     = var.project
  }
}

resource "aws_s3_object" "init_train" {
  bucket = aws_s3_bucket.processed.id
  key    = "processed/train/.keep"
  content = ""
}

resource "aws_s3_object" "init_validation" {
  bucket = aws_s3_bucket.processed.id
  key    = "processed/validation/.keep"
  content = ""
}

resource "aws_s3_object" "init_model_output" {
  bucket = aws_s3_bucket.processed.id
  key    = "model/output/.keep"
  content = ""
}

resource "aws_s3_object" "init_predictions" {
  bucket = aws_s3_bucket.processed.id
  key    = "predictions/.keep"
  content = ""
}

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
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.processed.arn,
      "${aws_s3_bucket.processed.arn}/*"
    ]
  }

  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }

  statement {
    actions = [
      "cloudwatch:PutMetricData"
    ]
    resources = ["*"]
  }
}

resource "aws_sagemaker_notebook_instance" "notebook" {
  name                 = "${var.project}-${var.env}-sagemaker-notebook"
  instance_type        = "ml.t3.medium"
  role_arn             = aws_iam_role.sagemaker_execution_role.arn
  lifecycle_config_name = var.lifecycle_config_name
  tags = {
    Project     = var.project
    Environment = var.env
  }
}

resource "aws_lambda_function" "sfn_starter" {
  function_name = "${var.project}-${var.env}-sfn-starter"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"

  filename         = "lambda/sfn_starter.zip"
  source_code_hash = filebase64sha256("lambda/sfn_starter.zip")

  environment {
    variables = {
      STEP_FUNCTION_ARN = aws_sfn_state_machine.pipeline.arn
    }
  }

  tags = {
    Environment = var.env
    Project     = var.project
  }
}

resource "aws_iam_role_policy" "lambda_sfn_access" {
  name = "${var.project}-${var.env}-lambda-sfn"
  role = aws_iam_role.lambda_exec.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = "states:StartExecution",
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_permission" "allow_s3_to_start_sfn" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sfn_starter.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.raw_ingest.arn
}

resource "aws_s3_bucket_notification" "sfn_trigger" {
  bucket = aws_s3_bucket.raw_ingest.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.sfn_starter.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_s3_to_start_sfn]
}