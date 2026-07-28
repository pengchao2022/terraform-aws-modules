variable "name" {
  description = "The name of the cluster, used as a prefix for all created resources"
  type        = string
}

variable "engine" {
  description = "The engine for this cluster"
  type        = string
}

variable "engine_version" {
  description = "The database engine version, updating this argument results in an outage "
  type        = string
  default     = "8.0.mysql_aurora.3.07.0"
}

variable "database_name" {
  description = "The name of the initial database to be created when the cluster is provisioned"
  type        = string
}

variable "username" {
  description = "The master username for the database"
  type        = string
}

variable "password" {
  description = "The master password for the database, should be managed via secrets manager"
  type        = string
  sensitive   = true
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether to enable mappings of AWS Identity and Access Management (IAM) accounts to database accounts"
  type        = bool
  default     = false
}

variable "db_subnet_group_name" {
  description = "A subnet group to associate with this DB cluster"
  type        = string
}

variable "vpc_security_group_ids" {
  description = "A list of VPC security group IDs to associate with the cluster"
  type        = list(string)
}

variable "instance_count" {
  description = "The total number of DB instances to create in the cluster (1 writer + N - 1 readers)"
  type        = number
  default     = 2
}

variable "instance_class" {
  description = "The compute and memory capacity of each DB isntance e.g., db.t4g.medium"
  type        = string
  default     = "db.t4g.medium"
}

variable "tags" {
  description = "Here you can write the resource tags like Name will be displayed on aws console first column"
  type        = map(string)
  default     = {}  
}