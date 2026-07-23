variable "identifier" {
  description = "The only identifier for this db instance"
  type        = string
}

variable "engine" {
  description = "The engine type of this db instance e.g., mysql, postgres"
  type        = string
}

variable "engine_version" {
  description = "The version of db instance engine"
  type        = string
  default     = "8.0"
}


variable "instance_class" {
  description = "The instance type of this db instance e.g., db.t3.micro, db.t3.small"
  type        = string  
}

variable "allocated_storage" {
  description = "The storage which this db instance have GB unit"
  type        = number
}

variable "username" {
  description = "The username for this db instance"
  type        = string
}

variable "password" {
  description = "The password of this db instance"
  type        = string
  sensitive   = true
}

variable "db_subnet_group_name" {
  description = "The subnet group which must contains two azs for this db instance"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "The security group ids which allowed to access this db instance"
  type        = list(string)
}

variable "max_allocated_storage" {
  description = "The max allocated storage for this db instance storage autoscaling"
  type        = number
}

variable "replica_count" {
  description = "Number of read replicas to create"
  type        = number
  default     = 0 
}

variable "backup_retention_period" {
  description = "The automatically backup days e.g. every 30 days backup once"
  type        = number
  default     = 30
  
}

variable "backup_window" {
  description = "The maintenance time window for this backup"
  type        = string
  default     = "03:00-04:00"
  
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether to enable mappings of AWS Identity and Access Management (IAM) accounts to database accounts"
  type        = bool
  default     = false
}

variable "tags" {
  description = "The name where you can write then displayed on aws cosole first column"
  type        = map(string)
  default     = {}
}
