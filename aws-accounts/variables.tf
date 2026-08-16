variable "accounts" {
  description = "需要创建的账号列表，包含名称、邮箱和可选的 OU ID"
  type = map(object({
    name      = string
    email     = string
    parent_id = optional(string) # 可选：如果不填，默认放在 Root 根节点下
  }))
}