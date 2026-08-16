resource "aws_organizations_account" "this" {
  for_each = var.accounts

  name      = each.value.name
  email     = each.value.email
  role_name = "OrganizationAccountAccessRole"
  
  # 直接在这里指定 parent_id，AWS Provider 会在创建时自动将其放入对应 OU
  # 如果不填，默认就是 Root
  parent_id = each.value.parent_id
}