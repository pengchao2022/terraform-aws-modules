variable "name" {
  description = "The name of this security group"
  type        = string
}

variable "description" {
  description = "The description words for this security group"
  type        = string
  default     = "Security group for https"
}

variable "vpc_id" {
  description = "The VPC ID which the security group belongs to"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "The cidr blocks which allowed by this security group"
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
}

variable "tags" {
  description = "the place you can set the name and environment so that can display in console fist column"
  type        = map(string)
  default = {}
}