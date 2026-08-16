variable "parent_id" {
  type        = string
  description = "父节点的 ID (可以是根节点 ID 如 r-xxxx，或者是上级 OU ID)"
}

variable "ou_name" {
  type        = string
  description = "要创建的组织单元 (OU) 名称 (例如: Production 或 Development)"
}