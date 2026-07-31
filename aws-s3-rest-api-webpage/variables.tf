variable "bucket_name" {
  description = "The S3 bucket name should be globally unique"
  type        = string
}

variable "tags" {
  description = "The resource tags"
  type        = map(string)
  default     = {}
}

