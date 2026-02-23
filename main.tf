resource "aws_lambda_function" "this" {
  function_name = "${var.project}-${var.env}-${var.function_name_suffix}"
  role          = var.lambda_exec_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.10"

  filename         = var.zip_path
  source_code_hash = filebase64sha256(var.zip_path)

  environment {
    variables = {
      STEP_FUNCTION_ARN = var.step_function_arn
    }
  }

  tags = {
    Environment = var.env
    Project     = var.project
  }
}

resource "aws_lambda_permission" "allow_s3_to_start" {
  count         = var.s3_raw_arn != null ? 1 : 0
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.s3_raw_arn
}

resource "aws_s3_bucket_notification" "s3_trigger" {
  count  = var.s3_raw_id != null ? 1 : 0
  bucket = var.s3_raw_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.this.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".csv"
  }

  depends_on = [aws_lambda_permission.allow_s3_to_start]
}