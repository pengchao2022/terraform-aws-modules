output "account_ids" {
  description = "创建的 AWS 账号 ID 映射"
  value       = { for k, v in aws_organizations_account.this : k => v.id }
}

output "account_arns" {
  description = "创建的 AWS 账号 ARN 映射"
  value       = { for k, v in aws_organizations_account.this : k => v.arn }
}