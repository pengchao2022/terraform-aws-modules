output "instance_profile_name" {
  description = "the name EC2 instance profile"
  value       = aws_iam_instance_profile.this.name
}

output "iam_role_arn" {
  description = "the arn of IAM role"
  value       = aws_iam_role.ec2_s3_role.arn
}