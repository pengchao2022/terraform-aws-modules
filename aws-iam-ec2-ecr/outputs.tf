output "role_arn" {
  description = "The ARN of the IAM role"
  value       = aws_iam_role.this.arn
}

output "role_name" {
  description = "The name of the IAM role"
  value       = aws_iam_role.this.name
}

output "instance_profile_name" {
  description = "The name of the instance profile to attach to your EC2 instance"
  value       = aws_iam_instance_profile.this.name
}

output "instance_profile_arn" {
  description = "The ARN of the instance profile"
  value       = aws_iam_instance_profile.this.arn
}