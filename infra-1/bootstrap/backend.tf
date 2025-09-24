terraform {
  backend "s3" {
    bucket  = "bootstrap-tf-state02" # your S3 bucket
    key     = "infra_plus_bootstrap/terraform.tfstate"                           # path inside the bucket
    region  = "us-east-1"
    encrypt = true
  }
}