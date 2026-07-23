output "repository_uri" {
  description = "The URI of the public ECR repository"
  value       = aws_ecrpublic_repository.this.repository_uri
}

output "repository_arn" {
  description = "The ARN of the public ECR repository"
  value       = aws_ecrpublic_repository.this.arn
}

output "repository_name" {
  description = "The name of the public ECR repository"
  value       = aws_ecrpublic_repository.this.repository_name
}