output "grafana_security_group_id" {
  value = aws_security_group.grafana.id
}

output "grafana_security_group_arn" {
  value = aws_security_group.grafana.arn
}