variable "vpc_id" {
  description = "The ID for the VPC"
  type        = string 
}

variable "service_name" {
  description = "The kind service of name"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of subnets"
  type        = list(string)
  default     = []
}

variable "security_group_ids" {
  description = "The security group ids"
  type        = list(string)
  default     = []
}

variable "environment" {
  description = "The deployment environment (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "private_dns_enabled" {
  description = "Whether to enable private dns support"
  type        = bool
  default     = true
}