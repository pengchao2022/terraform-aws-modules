variable "project_name" {
  description = "The name for this project"
  type        = string 
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "The CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16" 
}


variable "public_subnets_cidr" {
  description = "The CIDR block for public subnets"
  type        = list(string)
  default     = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24" ]
}

variable "private_subnets_cidr" {
  description = "The CIDR block for private subnets"
  type        = list(string)
  default     = [ "10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24" ]
}

variable "nat_gateway_count" {
  description = "Numbers of NAT Gateway"
  type        = number
  default     = 1 
}

variable "public_subnet_tags" {
  description = "public subnet tags used for EKS"
  type        = map(string)
  default     = {}
}

variable "private_subnet_tags" {
  description = "private subnet tags used for EKS"
  type        = map(string)
  default     = {}
}
