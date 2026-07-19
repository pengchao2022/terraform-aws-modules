output "user_name" {
  description = "The name of IAM user"
  value       = aws_iam_user.this.name
}

output "user_arn" {
  description = "The arn of IAM user"
  value       = aws_iam_user.this.arn 
}

output "password" {
  value = try(aws_iam_user_login_profile.this[0].password, "Not Created")
  sensitive = true
}

output "access_key_id" {
  description = "The ID of the Access Key (if created)"
  value = try(aws_iam_access_key.this[0].id, "Not Created")
}

output "secret_access_key" {
  description = "The Secret Access Key (if created)"
  value     = try(aws_iam_access_key.this[0].secret, "Not Created")
  sensitive = true
}

