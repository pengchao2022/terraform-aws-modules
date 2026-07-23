variable "name" {
  description = "The name of this security group"
  type        = string  
}

variable "description" {
  description = "The description words for this security group"
  type        = string
  default     = "Security group for Redis"
}

variable "vpc_id" {
  description = "The ID of VPC which this security group belongs to"
  type        = string  
}

variable "allowed_cidr_blocks" {
  description = "The cidr blocks which this security group allows"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "The coming security groups IDs which this security allows "
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Here you can write the Name which will be displayed on AWS console first column"
  type        = map(string)
  default = {}
}

