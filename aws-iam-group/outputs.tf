output "name" {
  value = aws_iam_group.this.name
}

output "arn" {
  value = aws_iam_group.this.arn
}

output "id" {
  description = "The unique ID assigned by AWS to the IAM group"
  value       = aws_iam_group.this.id
}