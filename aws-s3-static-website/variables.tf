variable "bucket_name" {
  description = "The name of S3 bucket should be globally unique"
  type        = string
}

variable "index_document" {
  description = "Index document for the static website"
  type        = string
  default     = "index.html"  
}

variable "error_document" {
  description = "The error document for the static website"
  type        = string
  default     = "error.html"
}

variable "tags" {
  description = "The resource tags"
  type        = map(string)
  default    = {}
}