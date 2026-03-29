output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.class7_gut_check_bucket.id
}

output "bucket_arn" {
  description = "ARN of the created S3 bucket"
  value       = aws_s3_bucket.class7_gut_check_bucket.arn
}
