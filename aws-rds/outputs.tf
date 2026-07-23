output "db_intance_id" {
  description = "The ID of this db instance"
  value       = aws_db_instance.this.id
}

output "db_instance_dns" {
  description = "The DNS address for this db instance"
  value       = aws_db_instance.this.address
}

output "db_instance_endpoint" {
  description = "the endpoint of this db instance for connection"
  value       = aws_db_instance.this.endpoint
}

output "db_instance_port" {
  description = "The port of this db instance"
  value       = aws_db_instance.this.port
}

output "db_instance_arn" {
  description = "The arn of this db_instance"
  value       = aws_db_instance.this.arn
}

output "db_replica_endpoints" {
  description = "A list of connection endpoints for all read replicas."
  value       = aws_db_instance.replica[*].endpoint
}

output "db_replica_arns" {
  description = "A list of ARNs for all read replicas."
  value       = aws_db_instance.replica[*].arn
}