output "iam_role_arn" {
  value       = aws_iam_role.this.arn
  description = "IAM Role ARN for Amazon EBS CSI Driver Controller"
}