terraform {
  backend "s3" {
    bucket  = "my-react-node-app-terraform-state-bootstrap" # your S3 bucket
    key     = "infra_plus_bootstrap/terraform.tfstate"                           # path inside the bucket
    region  = "us-east-1"
    encrypt = true
  }
}