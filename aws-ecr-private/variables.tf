variable "repository_name" {
  description = "The name of the private ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository: MUTABLE or IMMUTABLE"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Boolean to indicate whether images are scanned after being pushed"
  type        = bool
  default     = true
}

variable "lifecycle_policy" {
  description = "The JSON string for the ECR lifecycle policy"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}