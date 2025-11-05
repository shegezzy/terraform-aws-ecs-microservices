# Remote backend configuration
# Note: You need to create the S3 bucket and DynamoDB table manually before using this backend
# terraform {
#   backend "s3" {
#     bucket         = "terraform-aws-ecs-microservices-state"
#     key            = "terraform.tfstate"
#     region         = "us-east-1"
#     encrypt        = true
#     dynamodb_table = "terraform-aws-ecs-microservices-lock"
#   }
# }
