aws_region  = "us-east-1"
bucket_name = "my-react-node-app-bucket02"
#container_image       = "203918840508.dkr.ecr.us-east-1.amazonaws.com/my-react-node-app-image:latest"
backend_desired_count = 1

# AWS credentials for local dev
#AWS_ACCESS_KEY_ID     = "YOUR_AWS_ACCESS_KEY_ID"
#AWS_SECRET_ACCESS_KEY = "YOUR_AWS_SECRET_ACCESS_KEY"
ecs_cluster_name      = "my-react-node-app-cluster"
ecs_service_name      = "my-react-node-app-service"
alb_name              = "my-react-node-app-alb"
target_group_name     = "my-react-node-app-tg"