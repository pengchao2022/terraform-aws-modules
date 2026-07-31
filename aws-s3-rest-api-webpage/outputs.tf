output "bucket_regional_domain_name" {
  value       = aws_s3_bucket.this.bucket_regional_domain_name
  description = "The regional REST API domain name of the S3 bucket (Supports HTTPS)"
}

output "index_url" {
  value       = "https://${aws_s3_bucket.this.bucket_regional_domain_name}/index.html"
  description = "Direct HTTPS URL to index.html"
}