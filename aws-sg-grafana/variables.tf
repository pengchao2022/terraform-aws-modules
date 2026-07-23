variable "name" {
  description = "The name of this security group"
  type        = string
}

variable "description" {
  description = "The description words for this group"
  type        = string
  default     = "Grafana security group"
}

variable "vpc_id" {
  description = "The ID of VPC which this security group belongs to"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "The allowed network cidrs for this security group"
  type        = list(string)
  default     = []
}

variable "allowed_security_group_ids" {
  description = "The IDs of security group which can be allowed in this security group"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Here you can write the Name which will be displayed on aws console first column"
  type        = map(string)
  default     = {}
}
