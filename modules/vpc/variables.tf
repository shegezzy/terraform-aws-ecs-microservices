variable "name" {
  type        = string
  description = "The name prefix for all resources in this VPC module"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment name (dev/staging/prod)"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones to deploy the subnets in, e.g., ['us-east-1a','us-east-1b','us-east-1c']"
}

variable "region" {
  type        = string
  description = "AWS region for VPC endpoints"
  default     = "us-east-1"
}
