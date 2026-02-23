output "raw_ingest_bucket" {
  value = aws_s3_bucket.raw_ingest.bucket
}

output "raw_ingest_bucket_arn" {
  value = aws_s3_bucket.raw_ingest.arn
}

output "processed_bucket" {
  value = aws_s3_bucket.processed.bucket
}

output "processed_bucket_arn" {
  value = aws_s3_bucket.processed.arn
}