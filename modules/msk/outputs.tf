output "msk_cluster_arn" {
  description = "ARN of the MSK cluster"
  value       = aws_msk_cluster.this.arn
}

output "msk_cluster_name" {
  description = "MSK cluster name"
  value       = aws_msk_cluster.this.cluster_name
}

output "msk_bootstrap_brokers" {
  description = "Bootstrap brokers for client connections"
  value       = aws_msk_cluster.this.bootstrap_brokers_tls
}

output "msk_sg_id" {
  description = "Security group ID for MSK"
  value       = aws_security_group.msk_sg.id
}
