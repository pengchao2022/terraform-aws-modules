variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = "1.28"
}

variable "vpc_id" {
  description = "VPC ID where the cluster will be created"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR of kubernetes VPC"
  type        = string
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "A list of public subnet IDs for resources that require public routing"
  default     = []
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "A list of private subnet IDs for secure worker nodes and internal components"
  default     = []
}

variable "cluster_endpoint_private_access" {
  description = "Enable private API server endpoint"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Enable public API server endpoint"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to access the public endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "kms_key_arn" {
  description = "ARN of existing KMS key for secrets encryption (if null, a new key will be created)"
  type        = string
  default     = null
}


variable "create_managed_node_group" {
  description = "Whether to create a managed node group"
  type        = bool
  default     = true
}

variable "node_group_name" {
  description = "Name of the node group"
  type        = string
  default     = "main"
}

variable "node_subnet_ids" {
  description = "List of subnet IDs for nodes (if not set, uses cluster subnet_ids)"
  type        = list(string)
  default     = null
}

variable "instance_types" {
  description = "List of EC2 instance types for nodes"
  type        = list(string)
  default     = ["t3.medium"]
}

variable "capacity_type" {
  description = "Capacity type: ON_DEMAND or SPOT"
  type        = string
  default     = "ON_DEMAND"
  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "Capacity type must be either ON_DEMAND or SPOT."
  }
}

variable "min_size" {
  description = "Minimum number of nodes"
  type        = number
  default     = 1
}

variable "max_size" {
  description = "Maximum number of nodes"
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "Desired number of nodes"
  type        = number
  default     = 1
}

variable "max_unavailable" {
  description = "Maximum number of nodes unavailable during update"
  type        = number
  default     = 1
}

variable "root_volume_size" {
  description = "Size of root volume in GB"
  type        = number
  default     = 20
}

variable "root_volume_type" {
  description = "Type of root volume (gp2, gp3, io1, etc.)"
  type        = string
  default     = "gp3"
}

variable "ami_id" {
  description = "AMI ID for ubuntu if you want to use ubuntu EC2 instance"
  type        = string
  default    = "ami-0b6d9d3d33ba97d99"
}

variable "node_groups" {
  description = "Map of node groups to create"
  type        = map(any)
  default     = {}
}

variable "node_labels" {
  description = "Kubernetes labels to apply to nodes"
  type        = map(string)
  default     = {}
}

variable "enable_ssm_access" {
  description = "Enable SSM access for debugging nodes"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
  default     = {}
}