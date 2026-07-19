output "arn" {
  description = "The ARN of the IAM policy"
  value       = aws_iam_policy.this.arn
}

output "name" {
  description = "The name of the IAM policy"
  value       = aws_iam_policy.this.name
}