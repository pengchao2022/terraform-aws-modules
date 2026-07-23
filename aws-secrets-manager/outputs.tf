output "secret_arn" {
  description = "The ARN of the secrets manager secret"
  value       = aws_secretsmanager_secret.this.arn
}

output "secret_id" {
  description = "The ID of the secrets manager secret"
  value       = aws_secretsmanager_secret.this.id
}

output "secret_name" {
  description = "The name of the secrets manager secret"
  value       = aws_secretsmanager_secret.this.name
}

output "password" {
  value     = var.create_random_password ? random_password.this[0].result : var.secret_string
  sensitive = true
}