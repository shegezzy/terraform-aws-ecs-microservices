output "ecs_task_execution_role_arn" {
  description = "ARN of ECS Task Execution Role"
  value       = aws_iam_role.ecs_task_execution.arn
}

output "ecs_task_role_arn" {
  description = "ARN of ECS Task Role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "ecs_task_policy_arn" {
  description = "ARN of ECS Task Policy attached to task role"
  value       = aws_iam_policy.ecs_task_policy.arn
}
