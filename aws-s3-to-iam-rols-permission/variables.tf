variable "bucket_name" {
  description = "The name of the existing S3 bucket"
  type        = string
}

variable "iam_role_arns" {
  description = "List of IAM role names to be granted access to the S3 bucket"
  type        = list(string)
  default     = []
}