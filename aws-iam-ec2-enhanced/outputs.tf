output "iam_role_arn" {
  description = "The ARN of the created EC2 IAM Role"
  value       = aws_iam_role.ec2_s3_role.arn
}

output "instance_profile_name" {
  description = "The name of the IAM instance profile for EC2"
  value       = aws_iam_instance_profile.this.name
}