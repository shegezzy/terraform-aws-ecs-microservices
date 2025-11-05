variable "name" {
  type        = string
  description = "Name prefix for Redis resources"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment (dev/staging/prod)"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where Redis will reside"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet IDs for Redis"
}

variable "allowed_sg_ids" {
  type        = list(string)
  description = "List of security groups allowed to access Redis (e.g., ECS service SG)"
}

variable "engine_version" {
  type        = string
  default     = "6.x"
  description = "Redis engine version"
}

variable "node_type" {
  type        = string
  default     = "cache.t3.medium"
  description = "ElastiCache node type"
}

variable "num_cache_clusters" {
  type        = number
  default     = 2
  description = "Number of cache clusters (replicas)"
}

variable "multi_az" {
  type        = bool
  default     = true
  description = "Enable Multi-AZ for high availability"
}

variable "port" {
  type        = number
  default     = 6379
  description = "Redis port"
}

variable "maintenance_window" {
  type        = string
  default     = "sun:05:00-sun:06:00"
  description = "Preferred maintenance window for Redis"
}
