output "redis_primary_endpoint" {
  description = "Primary endpoint for Redis"
  value       = aws_elasticache_replication_group.this.primary_endpoint_address
}

output "redis_reader_endpoint" {
  description = "Reader endpoint for Redis (replicas)"
  value       = aws_elasticache_replication_group.this.reader_endpoint_address
}

output "redis_port" {
  description = "Redis port"
  value       = aws_elasticache_replication_group.this.port
}

output "redis_sg_id" {
  description = "Security group ID for Redis"
  value       = aws_security_group.redis_sg.id
}
