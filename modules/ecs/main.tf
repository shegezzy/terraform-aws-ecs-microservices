########################################
# ECS CLUSTER
########################################
resource "aws_ecs_cluster" "this" {
  name = var.cluster_name

  tags = {
    Name        = var.cluster_name
    Environment = var.environment
  }
}

########################################
# SECURITY GROUP FOR SERVICES
########################################
resource "aws_security_group" "service_sg" {
  name        = "${var.cluster_name}-svc-sg"
  description = "Security group for ECS services"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = var.environment
  }
}

########################################
# APPLICATION LOAD BALANCER
########################################
resource "aws_lb" "alb" {
  name               = "${var.cluster_name}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.alb_sg_id]

  tags = {
    Environment = var.environment
  }
}

########################################
# TARGET GROUPS (ONE PER SERVICE)
########################################
resource "aws_lb_target_group" "tg" {
  for_each = var.services

  name        = "${each.key}-tg"
  port        = each.value.container_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/health"
    matcher             = "200-399"
    interval            = 30
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Environment = var.environment
  }
}

########################################
# ALB LISTENER
########################################
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Not Found"
      status_code  = "404"
    }
  }
}

########################################
# ECS TASK DEFINITIONS
########################################
resource "aws_ecs_task_definition" "task" {
  for_each = var.services

  family                   = "${var.cluster_name}-${each.key}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = each.value.cpu
  memory                   = each.value.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = each.key
      image     = each.value.image
      portMappings = [
        {
          containerPort = each.value.container_port
          protocol      = "tcp"
        }
      ]
      environment  = each.value.env
      secrets      = each.value.secrets
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = "/ecs/${var.cluster_name}"
          "awslogs-region"        = var.region
          "awslogs-stream-prefix" = each.key
        }
      }
    }
  ])
}

########################################
# ECS SERVICES
########################################
resource "aws_ecs_service" "svc" {
  for_each = aws_ecs_task_definition.task

  name            = each.key
  cluster         = aws_ecs_cluster.this.id
  desired_count   = lookup(var.services[each.key], "desired_count", 2)
  launch_type     = "FARGATE"
  task_definition = each.value.arn

  network_configuration {
    subnets         = var.private_subnets
    security_groups = [aws_security_group.service_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.tg[each.key].arn
    container_name   = each.key
    container_port   = var.services[each.key].container_port
  }

  depends_on = [aws_lb_listener.http]
}

########################################
# AUTOSCALING
########################################
resource "aws_appautoscaling_target" "ecs_scaling_target" {
  for_each = aws_ecs_service.svc

  max_capacity       = var.services[each.key].autoscaling.max
  min_capacity       = var.services[each.key].autoscaling.min
  resource_id        = "service/${aws_ecs_cluster.this.name}/${each.key}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_policy" {
  for_each = aws_appautoscaling_target.ecs_scaling_target

  name                   = "${each.key}-cpu-policy"
  policy_type            = "TargetTrackingScaling"
  resource_id            = each.value.resource_id
  scalable_dimension     = each.value.scalable_dimension
  service_namespace      = each.value.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    target_value       = 55.0
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
