# app connect info
output "cluster_endpoint" {
  description = "The cluster endpoint for writing(primary)"
  value       = aws_rds_cluster.this.endpoint  
}

output "reader_endpoint" {
  description = "A read-only endpoint for the cluster, automatically load-balanced"
  value       = aws_rds_cluster.this.reader_endpoint
}

output "cluster_id" {
  description = "The ID of the RDS cluster"
  value       = aws_rds_cluster.this.id  
}

output "cluster_arn" {
  description = "The ARN of the RDS cluster"
  value       = aws_rds_cluster.this.arn
}

output "instance_id" {
  description = "A list of all instance identifiers in the cluster"
  value       = aws_rds_cluster_instance.this[*].id  
}

output "instance_endpoints" {
  description = "A list of endpoints for all instances in the cluster"
  value       = aws_rds_cluster_instance.this[*].endpoint
}