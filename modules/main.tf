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