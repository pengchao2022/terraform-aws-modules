variable "name" {
  description = "The name of this security group"
  type        = string
}

variable "description" {
  description = "The description words for this security group"
  type        = string
  default     = "Mysql access security group"
}

variable "vpc_id" {
  description = "The ID of VPC which this security group belongs to"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "The CIDR block which allow access for this security group"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "The security IDs which be allowed to access"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Here you can set the Name which will be displayed on AWS console first column"
  type        = map(string)
  default = {}
}