
# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.name}-ecs-task-execution"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
  })

  tags = {
    Name        = "${var.name}-ecs-task-execution"
    Environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


# ECS Task Role
resource "aws_iam_role" "ecs_task_role" {
  name = "${var.name}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = {
    Name        = "${var.name}-ecs-task-role"
    Environment = var.environment
  }
}


# Inline Policy for ECS Task Role
resource "aws_iam_policy" "ecs_task_policy" {
  name        = "${var.name}-ecs-task-policy"
  description = "Policy for ECS tasks to access AWS services"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      # S3 access
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = var.s3_resources
      },
      # SNS access
      {
        Effect   = "Allow"
        Action   = [
          "sns:Publish",
          "sns:Subscribe",
          "sns:ListTopics"
        ]
        Resource = var.sns_resources
      },
      # SQS access
      {
        Effect   = "Allow"
        Action   = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ]
        Resource = var.sqs_resources
      },
      # CloudFront invalidation
      {
        Effect   = "Allow"
        Action   = [
          "cloudfront:CreateInvalidation",
          "cloudfront:GetDistribution"
        ]
        Resource = var.cloudfront_resources
      },
      # Secrets Manager access
      {
        Effect   = "Allow"
        Action   = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.secrets_resources
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.ecs_task_policy.arn
}
