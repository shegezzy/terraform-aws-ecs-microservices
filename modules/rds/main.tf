# RDS Subnet Group
resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.private_subnets
  description = "Subnet group for RDS PostgreSQL"

  tags = {
    Name        = "${var.name}-rds-subnet-group"
    Environment = var.environment
  }
}



# Secrets Manager - DB Credentials
resource "aws_secretsmanager_secret" "db_secret" {
  name        = "${var.name}-db-secret"
  description = "RDS PostgreSQL credentials"
  tags = {
    Environment = var.environment
  }
}

resource "aws_secretsmanager_secret_version" "db_secret_version" {
  secret_id     = aws_secretsmanager_secret.db_secret.id
  secret_string = jsonencode({
    username = var.username
    password = var.password
  })
}


# RDS PostgreSQL Instance
resource "aws_db_instance" "this" {
  identifier         = "${var.name}-rds"
  engine             = "postgres"
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  allocated_storage  = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  db_name            = var.db_name
  username           = var.username
  password           = var.password
  port               = var.port
  storage_type       = "gp3"
  multi_az           = var.multi_az
  publicly_accessible = false
  skip_final_snapshot = false
  backup_retention_period = var.backup_retention_days
  db_subnet_group_name = aws_db_subnet_group.this.name
  vpc_security_group_ids = var.security_group_ids
  auto_minor_version_upgrade = true

  tags = {
    Name        = "${var.name}-rds"
    Environment = var.environment
  }

  depends_on = [aws_db_subnet_group.this]
}
