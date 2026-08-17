output "policy_arn" {
  description = "The ARN of the generated IAM policy."
  value       = aws_iam_policy.bucket_cmk_access_policy.arn
}

output "policy_id" {
  description = "The ID of the generated IAM policy."
  value       = aws_iam_policy.bucket_cmk_access_policy.id
}

output "attached_users" {
  description = "A list of IAM usernames that successfully received the policy attachment."
  value       = [for k, v in local.user_map : k]
}