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
  description = "The id of subnet"
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
  description = "the suffix of instance like web-1..."
  type        = set(string)
  default     = []
}

variable "public_key_content" {
  description = "id_rsa.pub的内容"
  type        = string
  
}


variable "existing_security_group_ids" {
  description = "exist Security group IDs"
  type        = list(string)
  default     = []
}


variable "iam_instance_profile" {
  description = "IAM profile"
  type        = string
  default     = "null"
}

variable "user_data" {
  description = "The shell scripts which run after EC2 started"
  type        = string
  default     = "null" 
}

variable "root_volume_size" {
  description = "the size of root volumn"
  type        = number
  default     = 20 
}

variable "public_ip_instances" {
  description = "The instances list which needs public IP address"
  type        = set(string)
  default     = [] 
}