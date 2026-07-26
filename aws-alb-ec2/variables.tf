variable "project_name" {
  description = "Project name used for naming resources"
  type        = string
}

variable "vpc_id" {
  description = "The ID of VPC which this ALB will be deployed"
  type        = string
}

variable "subnet_ids" {
  description = "List of public subnet IDs for the ALB"
  type        = list(string)
}

variable "target_port" {
  description = "Port on which EC2 application listens e.g. 80, 8080"
  type        = number
  default     = 80
}

variable "health_check_path" {
  description = "Health check HTTP path"
  type        = string
  default     = "/"
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN for HTTPS listener(optional)"
  default     = ""
}

variable "enable_deletion_protection" {
  description = "Enable deletion protection for ALB"
  type        = bool
  default     = false
}

variable "ec2_targets" {
  type        = map(string)
  description = "A map of EC2 target names to instance IDs, e.g. { app-1 = 'i-xxxx', app-2 = 'i-yyyy' }"
  default     = {}
}

variable "tags" {
  description = "Tags to apply to resources which will be displayed on AWS console first column"
  type        = map(string)
  default     = {}
}