variable "vpc_id" {
  type        = string
  description = "The VPC ID where the security group will be created."
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access RabbitMQ ports (e.g., your app servers or office IP)."
  default     = ["10.0.0.0/16"] # 默认限制在你的 VPC 内网网段，生产环境建议收紧
}

variable "allowed_admin_cidr_blocks" {
  type        = list(string)
  description = "List of CIDR blocks allowed to access the Management UI (port 15672). Keep this strict!"
  default     = [] # 建议仅允许运维人员的特定 IP 或内网堡垒机
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., production, staging)."
  default     = "production"
}