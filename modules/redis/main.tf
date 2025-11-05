# Security Group for Redis
resource "aws_security_group" "redis_sg" {
  name        = "${var.name}-redis-sg"
  description = "Security group for Redis"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = var.allowed_sg_ids
    description     = "Allow ECS services to access Redis"
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


# Redis Subnet Group
resource "aws_elasticache_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.private_subnets
  description = "Subnet group for Redis"

  tags = {
    Name        = "${var.name}-redis-subnet-group"
    Environment = var.environment
  }
}


# Redis Cluster
resource "aws_elasticache_replication_group" "this" {
  replication_group_id          = "${var.name}-redis"
  replication_group_description = "Redis replication group for microservices"
  engine                        = "redis"
  engine_version                = var.engine_version
  node_type                     = var.node_type
  number_cache_clusters         = var.num_cache_clusters
  automatic_failover_enabled    = var.multi_az
  subnet_group_name             = aws_elasticache_subnet_group.this.name
  security_group_ids            = [aws_security_group.redis_sg.id]
  port                          = var.port
  parameter_group_name          = "default.redis6.x"
  maintenance_window            = var.maintenance_window
  apply_immediately             = true
  transit_encryption_enabled    = true
  at_rest_encryption_enabled    = true
  tags = {
    Name        = "${var.name}-redis"
    Environment = var.environment
  }
}
