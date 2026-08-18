variable "project_name" {
  type        = string
  description = "The name of the project, used for resource naming prefixes and tagging"
}

variable "environment" {
  type        = string
  description = "The deployment environment (e.g., dev, staging, prod), used for naming and tagging"
}

variable "bucket_names" {
  type        = list(string)
  description = "A list of S3 bucket names that this EC2 instance role is allowed to access (GetObject, PutObject, ListBucket)"
  default     = []
}

variable "kms_key_arns" {
  type        = list(string)
  description = "Optional list of KMS key ARNs that this EC2 role needs permission to use for encryption and decryption"
  default     = []
}