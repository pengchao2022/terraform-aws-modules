output "security_group_rdp_id" {
  value = aws_security_group.this.id
}

output "security_group_rdp_arn" {
  value = aws_security_group.this.arn
}