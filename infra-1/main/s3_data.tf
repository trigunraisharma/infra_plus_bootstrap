# Fetch existing S3 bucket created via bootstrap
data "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}