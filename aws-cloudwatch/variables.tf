variable "log_group_name" {
  description = "The name of cloudwatch log group"
  type        = string
}

variable "retention_in_days" {
  description = "How long the logs will be keeped in cloudwatch"
  type        = number 
}

variable "archive_s3_bucket_arn" {
  description = "Export cloudwatch logs to aws s3"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "If has VPC ID will create vpc flow log automatically"
  type        = string
  default     = null
}

variable "traffic_type" {
  description = "The traffic type of VPC"
  type        = string
  default     = "REJECT"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}