resource "aws_s3_object" "github-repo-showing-files-pushed" {
  bucket       = aws_s3_bucket.class7_gutcheck_bucket.id
  key          = "github-repo-showing-files-pushed.png"
  source       = "./proof/github-repo-showing-files-pushed.png"
  content_type = "image/png"

  etag = filemd5("./proof/github-repo-showing-files-pushed.png")
}

resource "aws_s3_object" "gut-check-webhooks" {
  bucket       = aws_s3_bucket.class7_gutcheck_bucket.id
  key          = "gut-check-webhooks.png"
  source       = "./proof/gut-check-webhooks.png"
  content_type = "image/png"

  etag = filemd5("./proof/gut-check-webhooks.png")
}

resource "aws_s3_object" "Jenkins-5-stages-green" {
  bucket       = aws_s3_bucket.class7_gutcheck_bucket.id
  key          = "Jenkins-5-stages-green.png"
  source       = "./proof/Jenkins-5-stages-green.png"
  content_type = "image/png"

  etag = filemd5("./proof/Jenkins-5-stages-green.png")
}

resource "aws_s3_object" "outputs" {
  bucket       = aws_s3_bucket.class7_gutcheck_bucket.id
  key          = "outputs.png"
  source       = "./proof/outputs.png"
  content_type = "image/png"

  etag = filemd5("./proof/outputs.png")
}

resource "aws_s3_object" "TKO-Armageddon-link" {
  bucket       = aws_s3_bucket.class7_gutcheck_bucket.id
  key          = "TKO-Armageddon-link.md"
  source       = "./proof/TKO-Armageddon-link.md"
  content_type = "text/markdown"

  etag = filemd5("./proof/TKO-Armageddon-link.md")
}

resource "aws_s3_bucket" "README.md" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name = "class7-gutcheck-bucket"
  }
}

resource "aws_s3_bucket_public_access_block" "class7-gcheck" {
  bucket = aws_s3_bucket.class7_gutcheck_bucket.id

  block_public_acls  = true
  ignore_public_acls = true

  block_public_policy     = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "class7_gut_check" {
  bucket = aws_s3_bucket.class7_gutcheck_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicAccess"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.class7_gutcheck_bucket.arn}/*"
      }
    ]
  })
}
