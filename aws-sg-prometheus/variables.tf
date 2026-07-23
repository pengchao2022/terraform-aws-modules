variable "name" {
  description = "The name of this security group"
  type        = string
}

variable "description" {
  description = "The description words for this security group"
  type        = string
  default     = "Promethes security group"
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
  description = "The incoming security group ids which this security group allows"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Here you can set the Name which will display on aws console first column"
  type        = map(string)
  default     = {} 
}

variable "enable_prometheus_ui" {
  description = "This determine whether to open port for prometheus admin users"
  type        = bool
  default     = false
}

variable "enable_node_exporter" {
  description = "This determine whether to open port for client servers"
  type        = bool
  default     = false
}

variable "enable_pushgateway" {
  description = "This determine whether to open port for pushgateway"
  type        = bool
  default     = false
}
