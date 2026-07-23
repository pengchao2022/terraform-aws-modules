variable "name" {
  description = "The name of security group"
  type        = string
}

variable "description" {
  description = "The description words for this security group"
  type        = string
  default     = "The ICMP security group"
}

variable "vpc_id" {
  description = "The ID of VPC which this security group belongs to"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "The network IP cidrs which allowed ping command"
  type        = list(string)
  default     = [ "0.0.0.0/0" ]  
}

variable "tags" {
  description = "Here write the name of resource which can be displayed in aws console first column"
  type        = map(string)
  default = {}
}