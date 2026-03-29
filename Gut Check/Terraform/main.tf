## **main.tf**

resource "aws_s3_bucket" "class7_gut_check_bucket" {
bucket = var.bucket_name

tags = {
Name = "Class7-GutCheck"
Environment = "Lab"
ManagedBy = "Terraform"
}
}

resource "aws_s3_bucket_ownership_controls" "ownership" {
bucket = var.bucket_name.id
rule {
object_ownership = "BucketOwnerPreferred"
}
}

resource "aws_s3_object" "armageddon_clearance" {
for_each = fileset("${path.module}/../screenshots/", "*.png")

bucket = var.bucket_name.id
key = each.value
source = "${path.module}/../screenshots/${each.value}"
}