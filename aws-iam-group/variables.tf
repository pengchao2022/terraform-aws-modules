variable "name" {
  description = "The IAM group name"
  type        = string
}

variable "users" {
  description = "List of IAM usernames to add to this group"
  type        = list(string)
  default     = []
}

variable "aws_managed_policies" {
  description = "Map of AWS managed policy ARNs to attach to the group"
  type        = map(string)
  default = {}
}

variable "custom_policy_arns" {
  description = "List of custom policy ARNs to attach"
  type        = map(string)
  default     = {}
}
