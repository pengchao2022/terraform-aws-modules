variable "name" {
  description = "The name of this security group"
  type        = string
}

variable "description" {
  description = "The description words for this security group"
  type        = string
  default     = "The security group for SSH "
}

variable "vpc_id" {
  description = "The ID of VPC which this security group belongs to"
  type        = string 
}

variable "allowed_cidr_blocks" {
  description = "The IP network cidr which can be allowed by this security group"
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
}

variable "tags" {
  description = "Here is the place you can set the Name for the security group tag which can be displayed in aws console first column"
  type        = map(string)
  default = {}
}