output "policy_arn" {
  description = "The ARN of the created S3 access IAM policy"
  value       = aws_iam_policy.bucket_access_policy.arn
}

output "policy_name" {
  description = "The name of the created S3 access IAM policy"
  value       = aws_iam_policy.bucket_access_policy.name
}

output "granted_role_arns" {
  description = "List of IAM role ARNs that have been successfully granted access"
  value       = var.iam_role_arns
}