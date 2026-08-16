variable "bucket_name" {
  description = "The name of the existing S3 bucket"
  type        = string
}

variable "iam_user_arns" {
  description = "List of IAM user ARNs to be granted access to the S3 bucket"
  type        = list(string)
  default     = []
}