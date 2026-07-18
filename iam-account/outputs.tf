output "account_alias" {
  description = "The set account alias"
  value       = aws_iam_account_alias.alias.account_alias
}

output "password_policy_id" {
  description = "The ID of the password policy"
  value       = aws_iam_account_password_policy.policy.id
}