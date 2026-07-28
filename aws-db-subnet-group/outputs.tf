output "db_subnet_group_arn" {
  description = "The arn of the db subnet group"
  value       = aws_db_subnet_group.this.arn 
}

output "db_subnet_group_id" {
  description = "The db subnet group id"
  value       = aws_db_subnet_group.this.id
}