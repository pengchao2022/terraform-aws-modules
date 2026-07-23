variable "name" {
  description = "The name of this security group"
  type        = string
}

variable "description" {
  description = "The description words for this security group"
  type        = string
  default     = "Security group for HTTP-808"
}

variable "vpc_id" {
  description = "The VPC ID which this security group belongs to"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "The Network IP cidrs which this security group allowed"
  type        = list(string)
  default     = [ "0.0.0.0/0" ]
}

variable "tags" {
  description = "Here you can set the display name for the aws console first column Name"
  type        = map(string)
  default = {}
}