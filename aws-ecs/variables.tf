variable "cluster_name" {
  description = "The name of ECS cluster"
  type        = string
}

variable "service_name" {
  description = "The name of ECS service"
  type        = string
}

variable "container_name" {
  description = "The name of container which defined in task"
  type        = string
}

variable "container_image" {
  description = "The docker image which the container using"
  type        = string
}

variable "container_port" {
  description = "The port which the conainer listening"
  type        = number
}

variable "health_check_port" {
  type    = number
  default = 80
}

variable "cpu" {
  description = "The CPU units e.g. 512 = 0.5 vCPU"
  type        = number
  default     = 512
}

variable "memory" {
  description = "The memory assigned to the task Mib"
  type        = number
  default     = 1024
}

variable "desired_count" {
  description = "The expected task intance number"
  type        = number
  default     = null
}

variable "log_retention_days" {
  description = "CloudWatch logs retention period in days"
  type        = number
  default     = 7
}

variable "launch_type" {
  description = "The task instance type e.g. FARGATE or EC2"
  type        = string
  default     = "FARGATE"  
}

variable "assign_public_ip" {
  description = "The task instance whether to assign publick IP"
  type        = bool
  default     = false
}

variable "vpc_id" {
  description = "The ID of VPC which this ECS deployed"
  type        = string
}

variable "subnet_ids" {
  description = "The ID of subnet IDs which this ECS depployed"
  type        = list(string)
}

variable "target_group_arn" {
  description = "The target group arn which will be attached to alb"
  type        = string
}

variable "lb_security_group_id" {
  description = "Allowed security group IDs which alb to be used"
  type        = string
}

variable "rds_instance_id" {
  description = "The ID of the RDS instance"
  type        = string
  default     = null
}

variable "db_iam_user" {
  description = "The database user name for IAM authentication"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "This will support backend service e.g., RDS or database username, host etc,"
  type    = list(map(string))
  default = []
}