variable "vpc_id" {
  description = "The ID of VPC which this nlb will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of subnet which this nlb will be deployed"
  type        = list(string)
  default     = []
}

variable "rabbitmq_instance_ids" {
  description = "The EC2 IDs for the rabbitmq cluster"
  type        = list(string)
  default     = []
}

variable "is_internal" {
  description = "Whether the NLB is internal (true) or internet-facing (false)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}