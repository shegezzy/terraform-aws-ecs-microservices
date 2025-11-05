variable "name" {
  type        = string
  description = "Name prefix for the MSK cluster"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where MSK cluster will reside"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private subnet IDs for MSK brokers"
}

variable "allowed_sg_ids" {
  type        = list(string)
  description = "Security groups allowed to access MSK cluster"
}

variable "kafka_version" {
  type        = string
  default     = "3.5.1"
  description = "Kafka version"
}

variable "broker_nodes" {
  type        = number
  default     = 3
  description = "Number of broker nodes (odd number recommended)"
}

variable "broker_instance_type" {
  type        = string
  default     = "kafka.m5.large"
  description = "Broker EC2 instance type"
}

variable "ebs_volume_size" {
  type        = number
  default     = 100
  description = "EBS volume size per broker in GB"
}

variable "monitoring_level" {
  type        = string
  default     = "PER_BROKER"
  description = "MSK monitoring level: DEFAULT, PER_BROKER, PER_TOPIC_PER_BROKER"
}

variable "configuration_arn" {
  type        = string
  default     = ""
  description = "Optional MSK configuration ARN"
}

variable "configuration_revision" {
  type        = number
  default     = 0
  description = "Optional MSK configuration revision"
}

variable "cloudwatch_log_group" {
  type        = string
  description = "CloudWatch log group for MSK broker logs"
}
