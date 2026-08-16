output "policy_arns" {
  description = "Map of user names to their respective created policy ARNs"
  value       = { for k, policy in aws_iam_policy.bucket_access_policy : k => policy.arn }
}

output "bucket_arn" {
  description = "The ARN of the existing S3 bucket"
  value       = data.aws_s3_bucket.existing_bucket.arn
}