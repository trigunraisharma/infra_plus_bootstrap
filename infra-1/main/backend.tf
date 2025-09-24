terraform {
  backend "s3" {
    bucket         = "my-react-node-app-bucket02"   # Replace with your S3 bucket name
    key            = "infra_plus_bootstrap/terraform.tfstate" # Path inside bucket
    region         = "us-east-1"                   # Region for the bucket
    dynamodb_table = "terraform-locks"             # DynamoDB table for state locking
    encrypt        = true                          # Encrypt state file at rest
  }
}