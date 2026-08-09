output "account_alias" {
  description = "The set account alias"
  value       = aws_iam_account_alias.alias.account_alias
}

output "password_policy_id" {
  description = "The ID of the password policy"
  value       = aws_iam_account_password_policy.policy.id
}

output "signin_url" {
  description = "The IAM user sign-in URL with the account alias"
  value       = "https://${aws_iam_account_alias.alias.account_alias}.signin.aws.amazon.com/console"
}