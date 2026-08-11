variable "name" {
    description = "The name for resource tags use"
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
  description = "The AWS region of accept VPC"
  type        = string
}

variable "requester_route_table_ids" {
  description = "All the private route tables of request VPC"
  type        = list(string)
}

variable "accepter_route_table_ids" {
  description = "All the private route tables of accept VPC"
  type        = list(string) 
}