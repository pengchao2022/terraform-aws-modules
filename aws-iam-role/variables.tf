variable "name" {
  description = "The name of the IAM Role"
  type        = string
}

variable "description" {
  description = "The description words of the Role"
  type        = string
  default     = null  
}

variable "assume_role_policy_json" {
  description = "The JSON policy that grants an entity permission to assume the role (can be aws managed or customer policy)"
  type        = string
}

variable "inline_policy_json" {
  description = "Optional inline policy JSON"
  type        = string
  default     = null
}

variable "policy_arns" {
  description = "Map of policy ARNs to attach"
  type        = map(string)
  default = {}
}

variable "create_instance_profile" {
  description = "Whether to create an IAM instance profile for EC2"
  type        = bool
  default     = false
}

variable "tags" {
  description = "The tags for this Role"
  type        = map(string)
  default = {}
}