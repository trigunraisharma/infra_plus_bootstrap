terraform {
  backend "s3" {
    bucket         = "my-react-node-app-bucket02"   # Replace with your S3 bucket name
    key            = "terraform.tfstate" # Path inside bucket
    region         = "us-east-1"                   # Region for the bucket
    encrypt        = true                          # Encrypt state file at rest
  }
}