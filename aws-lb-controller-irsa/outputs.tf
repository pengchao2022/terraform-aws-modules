output "iam_role_arn" {
  value       = aws_iam_role.this.arn
  description = "IAM Role ARN for AWS Load Balancer Controller"
}