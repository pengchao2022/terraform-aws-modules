variable "account_alias" {
  description = "The account alias for the AWS account"
  type        = string
}

variable "minimum_password_length" {
  description = "Minimum length to require for user password"
  type        = number
  default     = 12
}

variable "max_password_age" {
  description = "The number of days that an user password is valid"
  type        = number
  default     = 90
}

variable "password_reuse_prevention" {
  description = "The number of previous passwords that users are prevented from reusing"
  type        = number
  default     = 3  
}

variable "require_symbols" {
  description = "Whether to require symbols for user passwords"
  type        = bool
  default     = true
}