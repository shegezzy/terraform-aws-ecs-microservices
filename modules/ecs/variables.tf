variable "cluster_name" {
  type        = string
  description = "Name of the ECS cluster"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment (dev/staging/prod)"
}

variable "region" {
  type        = string
  description = "AWS region to deploy resources"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where ECS cluster will reside"
}

variable "public_subnets" {
  type        = list(string)
  description = "List of public subnet IDs for ALB"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet IDs for ECS tasks"
}

variable "execution_role_arn" {
  type        = string
  description = "ARN of the ECS task execution role"
}

variable "task_role_arn" {
  type        = string
  description = "ARN of the ECS task role"
}

variable "services" {
  type = map(object({
    image          = string
    container_port = number
    cpu            = number
    memory         = number
    desired_count  = number
    autoscaling    = object({
      min = number
      max = number
    })
    env     = list(object({ name = string, value = string }))
    secrets = list(object({ name = string, valueFrom = string }))
  }))
  description = "Map of ECS services with configuration"
}
