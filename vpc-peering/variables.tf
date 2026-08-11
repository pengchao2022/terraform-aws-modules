variable "name" {
  description = "The name prefix for resource tags"
  type        = string
}

variable "requester_vpc_id" {
  description = "The id of request VPC"
  type        = string
}

variable "accepter_vpc_id" {
  description = "The id of accept VPC"
  type        = string
}

variable "requester_vpc_cidr" {
  description = "The CIDR block of request VPC"
  type        = string
}

variable "accepter_vpc_cidr" {
  description = "The CIDR block of accept VPC"
  type        = string
}

variable "accepter_region" {
  description = "The AWS region of accept VPC (Mandatory)"
  type        = string
}

variable "requester_route_table_ids" {
  description = "All the route tables of request VPC"
  type        = list(string)
}

variable "accepter_route_table_ids" {
  description = "All the route tables of accept VPC"
  type        = list(string)
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}