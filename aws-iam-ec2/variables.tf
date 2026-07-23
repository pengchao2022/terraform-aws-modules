variable "project_name" {
  description = "project name for resource tag"
  type        = string
}


variable "bucket_names" {
  description = "List of S3 bucket names"
  type        = list(string)
  default     = []
}

