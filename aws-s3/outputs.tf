output "bucket_name" {
  description = "The name of the bucket"
  value       = aws_s3_bucket.this.id
}


output "bucket_arn" {
  description = "The arn for this bucket"
  value       = aws_s3_bucket.this.arn 
}


