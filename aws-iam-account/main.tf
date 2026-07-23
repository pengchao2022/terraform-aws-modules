resource "aws_iam_account_alias" "alias" {
  account_alias = var.account_alias
}

resource "aws_iam_account_password_policy" "policy" {
  minimum_password_length        = var.minimum_password_length
  max_password_age               = var.max_password_age
  password_reuse_prevention      = var.password_reuse_prevention
  require_symbols                = var.require_symbols
  require_uppercase_characters   = true
  require_lowercase_characters   = true
  require_numbers                = true
  allow_users_to_change_password = true
}

