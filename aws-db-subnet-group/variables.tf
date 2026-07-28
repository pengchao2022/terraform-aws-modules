variable "name" {
  description = "The name of the db subnet group"
  type        = string
  default     = null
}

variable "description" {
  description = "The description words for this db subnet group"
  type        = string
  default = "db subnet group Managed by terraform"
}

variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "A mapping of tags to assign to the resource and will display on aws console first column"
  type        = map(string)
  default     = {}
}

