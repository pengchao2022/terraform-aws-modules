output "security_group_ssh_id" {
  value = aws_security_group.this.id
}

output "security_group_ssh_arn" {
  value = aws_security_group.this.arn 
}