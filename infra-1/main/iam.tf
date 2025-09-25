####################################################
# Get current AWS account info
####################################################
data "aws_caller_identity" "current" {}

data "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

####################################################
# ECS Execution Role
####################################################
resource "aws_iam_role" "ecs_execution_role" {
  name = "ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "ECSExecutionAssumeRole"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
      }
    ]
  })

  tags = { Environment = "dev", Project = var.name }
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

####################################################
# ECS User ECR Policy
####################################################
resource "aws_iam_policy" "ecs_user_ecr_policy" {
  name   = "ecs-user-ecr-policy"
  policy = file("${path.module}/policies/ecs-user-ecr-policy.json")
}

resource "aws_iam_user_policy_attachment" "ecs_user_ecr_custom" {
  user       = "ecs_user"
  policy_arn = aws_iam_policy.ecs_user_ecr_policy.arn
}

####################################################
# ECS Task Role
####################################################
resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "ECSTaskAssumeRole"
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
      }
    ]
  })
}

# ECS Task Policies
resource "aws_iam_policy" "ecs_task_s3_policy" {
  name   = "ecs-task-s3-access"
  policy = file("${path.module}/policies/ecs-task-s3-policy.json")
}

resource "aws_iam_policy" "ecs_task_ssm_policy" {
  name   = "ecs-task-ssm-access"
  policy = file("${path.module}/policies/ecs-task-ssm-policy.json")
}

resource "aws_iam_policy" "ssm_access" {
  name   = "TerraformSSMAccess"
  policy = file("${path.module}/policies/terraform-ssm-access.json")
}

resource "aws_iam_role_policy_attachment" "ecs_task_attach_s3" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_s3_policy.arn
}

resource "aws_iam_role_policy_attachment" "ecs_task_attach_ssm" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_ssm_policy.arn
}

resource "aws_iam_role_policy_attachment" "attach_ssm" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ssm_access.arn
}

####################################################
# S3 Bucket Policy for CloudFront
####################################################
resource "aws_s3_bucket_policy" "my-react-node-app-bucket02" {
  bucket = data.aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontGetObject"
        Effect = "Allow"
        Principal = { Service = "cloudfront.amazonaws.com" }
        Action   = "s3:GetObject"
        Resource = "${data.aws_s3_bucket.my_bucket.arn}/*"
        Condition = { StringEquals = { "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn } }
      }
    ]
  })
}