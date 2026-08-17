variable "description" {
  type        = string
  description = "The description of the key as viewed in AWS console."
  default     = "Managed by Terraform"
}

variable "deletion_window_in_days" {
  type        = number
  description = "Waiting period before KMS key is deleted. Valid values range from 7 to 30 days."
  default     = 30
}

variable "enable_key_rotation" {
  type        = bool
  description = "Specifies whether key rotation is enabled."
  default     = true
}

variable "alias_name" {
  type        = string
  description = "The display name of the alias. Must start with 'alias/'."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the KMS key."
  default     = {}
}