variable "project_name" {
  description = "The project which the EC2 used for"
  type        = string  
}

variable "environment" {
  description = "The environment of the EC2 used for"
  type        = string 
}

variable "vpc_id" {
  description = "The id of vpc"
  type        = string  
}

variable "subnet_map" {
  description = "The id of subnet mapping"
  type        = map(string)
}

variable "ami_id" {
  description = "The ami id for EC2"
  type        = string
}

variable "instance_type" {
  description = "The instance type of EC2"
  type        = string  
}

variable "instance_suffix" {
  description = "The suffix of instance like web-1..."
  type        = set(string)
  default     = []
}

variable "public_key_content" {
  description = "id_rsa.pub content"
  type        = string
}

variable "existing_security_group_ids" {
  description = "Exist Security group IDs"
  type        = list(string)
  default     = []
}

variable "iam_instance_profile" {
  description = "IAM profile name"
  type        = string
  default     = null # 告诉 Terraform：如果不传值，就“什么都不传” 那么就是不挂载任何 instance profile
}

variable "user_data" {
  description = "The shell scripts which run after EC2 started"
  type        = string
  default     = null # 告诉 Terraform：如果不传值，就“什么都不传” 那么就是不安装任何 自定义软件
}

variable "root_volume_size" {
  description = "The size of root volume (GB)"
  type        = number
  default     = 20 
}

variable "public_ip_instances" {
  description = "The instances list which needs public IP address"
  type        = set(string)
  default     = [] 
}


variable "tags" {
  description = "Additional tags for all resources"
  type        = map(string)
  default     = {}
}