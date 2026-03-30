resource "aws_s3_bucket" "class7_gut_check_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = "Class7-GutCheck"
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.class7_gut_check_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_object" "armageddon_clearance" {
  for_each = fileset("${path.module}/../Screenshots/", "*.png")

  bucket = aws_s3_bucket.class7_gut_check_bucket.id
  key    = each.value
  source = "${path.module}/../Screenshots/${each.value}"
}
