# 创建 IAM 用户
resource "aws_iam_user" "this" {
  name          = var.name
  force_destroy = var.force_destroy
}

# 配置控制台登录凭证
resource "aws_iam_user_login_profile" "this" {
  count                   = var.create_console_login ? 1 : 0
  user                    = aws_iam_user.this.name
  password_length         = 20
  password_reset_required = true
}

# 创建访问密钥 只有在 var.create_access_key 为 true 时才创建
resource "aws_iam_access_key" "this" {
  count   = var.create_access_key ? 1 : 0
  user    = aws_iam_user.this.name
}