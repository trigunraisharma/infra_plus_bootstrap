# ECR Repository
resource "aws_ecr_repository" "repo" {
  name                 = "${var.name}-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "${var.name}-repo"
  }
  force_delete = true
}

# Store repo URL in SSM so GitHub Actions can use it
resource "aws_ssm_parameter" "ecr_repo_url" {
  name        = "/${var.name}/ecr_repo_url"
  description = "ECR repo URL for backend"
  type        = "String"
  value       = aws_ecr_repository.repo.repository_url
  overwrite   = true
}

resource "aws_ecr_lifecycle_policy" "app_repo_policy" {
  repository = aws_ecr_repository.repo.name

  policy = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep only last 3 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 3
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}