variable "name" {
  description = "The name of the IAM user"
  type        = string
}

variable "force_destroy" {
  description = "When destroying this user, destroy even if it has non-terraform-managed IAM access keys"
  type        = bool
  default     = true
}

variable "create_console_login" {
  description = "Whether create AWS console access for IAM user (Console access)"
  type        = bool
  default     = false 
}

variable "create_access_key" {
  description = "Whether create Access key for IAM user (CLI access)"
  type        = bool
  default     = false
}

