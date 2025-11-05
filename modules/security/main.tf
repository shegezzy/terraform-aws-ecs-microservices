# ALB Security Group
resource "aws_security_group" "alb_sg" {
  name        = "${var.name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  # Allow HTTP from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from anywhere"
  }

  # Allow HTTPS if needed
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from anywhere"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name        = "${var.name}-alb-sg"
    Environment = var.environment
  }
}

# ECS Service Security Group
resource "aws_security_group" "ecs_sg" {
  name        = "${var.name}-ecs-sg"
  description = "Security group for ECS services"
  vpc_id      = var.vpc_id

  # Allow ALB to access ECS tasks
  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [aws_security_group.alb_sg.id]
    description     = "Allow traffic from ALB"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name        = "${var.name}-ecs-sg"
    Environment = var.environment
  }
}


# RDS Security Group
resource "aws_security_group" "rds_sg" {
  name        = "${var.name}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.rds_port
    to_port         = var.rds_port
    protocol        = "tcp"
    security_groups = var.allowed_rds_sg_ids
    description     = "Allow ECS tasks to access RDS"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-rds-sg"
    Environment = var.environment
  }
}

# Redis Security Group
resource "aws_security_group" "redis_sg" {
  name        = "${var.name}-redis-sg"
  description = "Security group for Redis"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.redis_port
    to_port         = var.redis_port
    protocol        = "tcp"
    security_groups = var.allowed_redis_sg_ids
    description     = "Allow ECS tasks to access Redis"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-redis-sg"
    Environment = var.environment
  }
}

# MSK Security Group
resource "aws_security_group" "msk_sg" {
  name        = "${var.name}-msk-sg"
  description = "Security group for MSK cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.kafka_port
    to_port         = var.kafka_port
    protocol        = "tcp"
    security_groups = var.allowed_msk_sg_ids
    description     = "Allow ECS tasks to access MSK brokers"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-msk-sg"
    Environment = var.environment
  }
}
