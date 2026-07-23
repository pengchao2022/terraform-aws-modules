variable "name" {
  description = "The name of secrets manager"
  type        = string
}

variable "description" {
  description = "The description words for this secrets manager"
  type        = string
  default     = "Aws secrets manager"  
}

variable "secret_string" {
  description = "This is the password you created by yourself. If you enable create_random_password, you do not need this."
  type        = string
  sensitive   = true
  default     = null
}

variable "kms_key_id" {
  description = "The id of kms key"
  type        = string
  default     = null  
}

variable "allowed_iam_roles" {
  description = "The roles which can read this secrets"
  type        = list(string)
  default     = []
}

variable "create_random_password" {
  description = "Create random password if you enable it"
  type        = bool
  default     = false
}

variable "random_password_length" {
  type        = number
  default     = 32
}

variable "rotation_after_days" {
  description = "Change the password after days"
  type        = number
  default     = 30
}

variable "tags" {
  description = "The Name which you can write and will be displayed on aws console first column"
  type        = map(string)
  default     = {}
}