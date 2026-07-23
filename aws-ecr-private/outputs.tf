output "repository_url" {
  description = "The URL of the private ECR repository"
  value       = aws_ecr_repository.this.repository_url
}

output "repository_arn" {
  description = "The ARN of the private ECR repository"
  value       = aws_ecr_repository.this.arn
}

output "repository_name" {
  description = "The name of the private ECR repository"
  value       = aws_ecr_repository.this.name
}