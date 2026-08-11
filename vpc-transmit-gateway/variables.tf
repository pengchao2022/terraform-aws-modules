variable "name" {
  description = "Name prefix for Transit Gateway and related resources"
  type        = string
}

variable "amazon_side_asn" {
  description = "Private Autonomous System Number (ASN) for the Amazon side of a BGP session"
  type        = number
  default     = 64512
}

variable "vpc_attachments" {
  description = "Map of VPC attachments configuration"
  type = map(object({
    vpc_id             = string
    subnet_ids         = list(string)
    route_table_ids    = list(string) # 需要添加 TGW 路由的子网路由表 ID 列表
    destination_cidr   = string       # 访问对方 VPC 的 CIDR 网段
  }))
  default = {}
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}