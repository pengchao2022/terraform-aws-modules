variable "name" {
  description = "The name of this security group"
  type        = string
}

variable "description" {
  description = "The description words for this security group"
  type        = string
  default     = "Allow RDP access for Win Server"
}

variable "vpc_id" {
  description = "The ID of VPC which this security group belongs to"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "The IP network cidrs which allow RDP access"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Here you can set Name for this security group which can be displayed in aws console first column"
  type        = map(string)
  default = {}
}