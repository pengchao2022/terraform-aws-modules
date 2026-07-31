output "website_endpoint" {
  description = "The public website endpoint URL of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.this.website_endpoint
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.this.id
  
}