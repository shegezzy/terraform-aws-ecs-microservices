variable "name" {
  type        = string
  description = "Name prefix for RDS resources"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment (dev/staging/prod)"
}

variable "private_subnets" {
  type        = list(string)
  description = "List of private subnet IDs where RDS will reside"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs to attach to RDS"
}

variable "db_name" {
  type        = string
  description = "Name of the PostgreSQL database"
}

variable "username" {
  type        = string
  description = "Master username for the database"
}

variable "password" {
  type        = string
  description = "Master password for the database"
  sensitive   = true
}

variable "port" {
  type        = number
  default     = 5432
  description = "Port for PostgreSQL"
}

variable "engine_version" {
  type        = string
  default     = "15.3"
  description = "PostgreSQL engine version"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.medium"
  description = "Instance class for RDS"
}

variable "allocated_storage" {
  type        = number
  default     = 20
  description = "Initial allocated storage in GB"
}

variable "max_allocated_storage" {
  type        = number
  default     = 100
  description = "Maximum allocated storage in GB"
}

variable "multi_az" {
  type        = bool
  default     = true
  description = "Whether to deploy Multi-AZ for high availability"
}

variable "backup_retention_days" {
  type        = number
  default     = 7
  description = "Number of days to retain automated backups"
}
