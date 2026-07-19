variable "bucket_name" {
  description = "The name of the bucket"
  type        = string  
}


variable "tags" {
  description = "The tag for bucket"
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Delete the s3 bucket which is not empty"
  type        = bool
  default     = false
}
