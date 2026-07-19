variable "name" {
  description = "The name of this kms key"
  type        = string  
}

variable "description" {
  description = "The description words for this kms key"
  type        = string
}

variable "allowed_iam_role_arns" {
  type    = list(string)
  default = []
}