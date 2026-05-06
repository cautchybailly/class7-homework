# Backend bucket configuration for Terraform state storage
terraform {
  backend "s3" {
    bucket  = "saba-jenkins-bucket"
    key     = "saba-jenkins-bucket/gutcheck/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}


resource "aws_s3_bucket" "class7_gutcheck_bucket" {
  bucket        = "class7-gut-check-bucket"
  force_destroy = true

  tags = {
    Name        = "Class7-GutCheck"
    Environment = "Buckets"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_ownership_controls" "class7_gutcheck_bucket" {
  bucket = aws_s3_bucket.class7_gutcheck_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "class7_gutcheck_bucket" {
  bucket = aws_s3_bucket.class7_gutcheck_bucket.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "class7_gutcheck_bucket" {
  depends_on = [
    aws_s3_bucket_ownership_controls.class7_gutcheck_bucket,
    aws_s3_bucket_public_access_block.class7_gutcheck_bucket,
  ]

  bucket = aws_s3_bucket.class7_gutcheck_bucket.id
  acl    = "public-read"
}

