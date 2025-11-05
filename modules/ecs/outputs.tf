output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.this.id
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "service_arns" {
  description = "Map of ECS service ARNs"
  value       = { for k, v in aws_ecs_service.svc : k => v.arn }
}

output "task_definitions" {
  description = "Map of ECS task definition ARNs"
  value       = { for k, v in aws_ecs_task_definition.task : k => v.arn }
}

output "ecs_sg_id" {
  description = "ID of the ECS services security group"
  value       = aws_security_group.service_sg.id
}
