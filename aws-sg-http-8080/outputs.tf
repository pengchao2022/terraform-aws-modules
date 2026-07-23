output "security_group_http_8080_id" {
  value = aws_security_group.this.id
}

output "security_group_http_8080_arn" {
  value = aws_security_group.this.arn 
}