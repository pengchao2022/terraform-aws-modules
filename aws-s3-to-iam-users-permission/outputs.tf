output "policy_arn" {
  description = "The ARN of the shared S3 access policy"
  value       = aws_iam_policy.bucket_access_policy.arn
}

output "bucket_arn" {
  description = "The ARN of the existing S3 bucket"
  value       = data.aws_s3_bucket.existing_bucket.arn
}