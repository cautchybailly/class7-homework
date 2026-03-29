output "bucket_name" {
description = "Name of the created S3 bucket"
value = var.bucket_name.id
}

output "bucket_arn" {
description = "ARN of the created S3 bucket"
value = var.bucket_name.arn
}