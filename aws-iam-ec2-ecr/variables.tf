variable "role_name" {
  description = "The name of the IAM role for EC2 ECR access"
  type        = string
  default     = "ec2-ecr-readonly-role"
}

variable "tags" {
  description = "A map of tags to assign to the IAM role"
  type        = map(string)
  default     = {}
}