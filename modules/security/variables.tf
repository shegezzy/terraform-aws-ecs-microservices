variable "name" {
  type        = string
  description = "Prefix name for all security groups"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where SGs will reside"
}

variable "rds_port" {
  type        = number
  default     = 5432
  description = "Port for RDS"
}

variable "redis_port" {
  type        = number
  default     = 6379
  description = "Port for Redis"
}

variable "kafka_port" {
  type        = number
  default     = 9092
  description = "Port for Kafka brokers"
}

variable "allowed_rds_sg_ids" {
  type        = list(string)
  default     = []
  description = "List of security group IDs allowed to access RDS"
}

variable "allowed_redis_sg_ids" {
  type        = list(string)
  default     = []
  description = "List of security group IDs allowed to access Redis"
}

variable "allowed_msk_sg_ids" {
  type        = list(string)
  default     = []
  description = "List of security group IDs allowed to access MSK"
}
