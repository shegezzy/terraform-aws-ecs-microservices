variable "name" {
  type        = string
  description = "Prefix name for IAM resources"
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "Deployment environment"
}

variable "s3_resources" {
  type        = list(string)
  default     = ["*"]
  description = "List of S3 ARNs ECS tasks can access"
}

variable "sns_resources" {
  type        = list(string)
  default     = ["*"]
  description = "List of SNS topic ARNs ECS tasks can access"
}

variable "sqs_resources" {
  type        = list(string)
  default     = ["*"]
  description = "List of SQS queue ARNs ECS tasks can access"
}

variable "cloudfront_resources" {
  type        = list(string)
  default     = ["*"]
  description = "List of CloudFront distributions ECS tasks can access"
}

variable "secrets_resources" {
  type        = list(string)
  default     = ["*"]
  description = "List of Secrets Manager secrets ECS tasks can access"
}
