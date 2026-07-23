variable "name" {
  description   = "The name of security group"
  type          = string  
}

variable "description" {
  description = "The description words for this security group"
  type        = string
  default     = "Security group for HTTP-80"
}

variable "vpc_id" {
  description = "The VPC ID for this security group"
  type        = string  
}

variable "allowed_cidr_blocks" {
  description = "Allowed IP network cidr"
  type        = list(string)
  default     = [ "0.0.0.0/0" ]  
}

variable "tags" {
  description = "For name using"
  type        = map(string)
  default     = {}
}
