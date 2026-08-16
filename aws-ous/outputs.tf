output "ou_id" {
  description = "创建的 OU ID"
  value       = aws_organizations_organizational_unit.this.id
}

output "ou_arn" {
  description = "创建的 OU ARN"
  value       = aws_organizations_organizational_unit.this.arn
}