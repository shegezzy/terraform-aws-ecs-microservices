# Security Group for MSK
resource "aws_security_group" "msk_sg" {
  name        = "${var.name}-msk-sg"
  description = "Security group for MSK cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = var.kafka_port
    to_port         = var.kafka_port
    protocol        = "tcp"
    security_groups = var.allowed_sg_ids
    description     = "Allow ECS services to access MSK brokers"
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


# MSK Cluster

resource "aws_msk_cluster" "this" {
  cluster_name           = var.name
  kafka_version          = var.kafka_version
  number_of_broker_nodes = var.broker_nodes
  enhanced_monitoring    = var.monitoring_level

  broker_node_group_info {
    instance_type = var.broker_instance_type
    storage_info {
      ebs_storage_info {
        volume_size = var.ebs_volume_size
      }
    }
    client_subnets  = var.private_subnets
    security_groups = [aws_security_group.msk_sg.id]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  configuration_info {
    arn      = var.configuration_arn
    revision = var.configuration_revision
  }

  tags = {
    Environment = var.environment
    Name        = var.name
  }

  logging_info {
    broker_logs {
      cloudwatch_logs {
        enabled   = true
        log_group = var.cloudwatch_log_group
      }
    }
  }

  depends_on = [aws_security_group.msk_sg]
}
