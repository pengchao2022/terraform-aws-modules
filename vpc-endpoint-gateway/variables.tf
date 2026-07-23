variable "region" {
  description = "The AWS region where the VPC and S3 endpoint will be created (e.g., us-east-1)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC where the S3 Gateway endpoint will be deployed"
  type        = string
}

variable "route_table_ids" {
  description = "A list of route table IDs that will be updated with a route to S3"
  type        = list(string)
}

variable "environment" {
  description = "The deployment environment name, used for naming tags (e.g., prod, dev, staging)"
  type        = string
  default     = "prod"
}

variable "service_name" {
  description = "The service name for the Gateway endpoint (e.g., s3 or dynamodb)"
  type        = string
  default     = "s3"

  validation {
    condition     = contains(["s3", "dynamodb"], var.service_name)
    error_message = "The service_name for a Gateway endpoint must be either 's3' or 'dynamodb'."
  }
}

variable "additional_tags" {
  description = "A map of additional tags to add to the S3 Gateway endpoint"
  type        = map(string)
  default     = {}
}