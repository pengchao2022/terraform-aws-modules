variable "name_prefix" {
  description = "The name prefix for resources"
  type        = string
  default     = "maxwell-vpn"
}

variable "tags" {
  description = "The resources tags"
  type        = map(string)
  default     = {}
}

variable "transit_gateway_id" {
  description = "The ID of the Transit Gateway to attach the VPN to."
  type        = string
}

variable "tgw_route_table_id" {
  description = "The ID of the Transit Gateway Route Table to associate the VPN route with."
  type        = string
}

variable "target_subnet_ids" {
  description = "The IDs of private subnets of the target VPC (for Client VPN network associations)"
  type        = list(string)
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the target VPC (for Client VPN authorization)"
  type        = string
}


variable "enable_s2s_vpn" {
  description = "Whether to enable the site-to-site VPN service"
  type        = bool
  default     = true
}

variable "customer_public_ip" {
  description = "The public IP of ISP-assigned public IP address for Site-to-Site VPN"
  type        = string
  default     = ""
}

variable "s2s_local_subnet_cidr" {
  description = "CIDR block of the local network on-premise"
  type        = string
  default     = "192.168.100.0/24"
}


variable "enable_client_vpn" {
  description = "Whether to enable the AWS Client VPN endpoint and its associated resources"
  type        = bool
  default     = true
}

variable "client_vpn_cidr" {
  description = "Client VPN IP network pool IPv4"
  type        = string
  default     = "10.200.0.0/22"
}

variable "client_common_name" {
  description = "Common name of cert for client VPN"
  type        = string
  default     = "maxwell-client"
}

variable "organization_name" {
  description = "Organization name for the certificate authority and subject"
  type        = string
  default     = "Maxwell Company"
}