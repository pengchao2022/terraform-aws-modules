variable "project_name" {
  description = "Project name for resource tag and naming prefix"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)"
  type        = string
}

variable "bucket_names" {
  description = "List of S3 bucket names for IAM policy access"
  type        = list(string)
  default     = []
}