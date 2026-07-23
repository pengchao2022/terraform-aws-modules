# 1. 创建 Secret 容器
resource "aws_secretsmanager_secret" "this" {
  name        = var.name
  description = var.description
  kms_key_id  = var.kms_key_id
  tags        = var.tags
}

# 2. 生成随机密码
resource "random_password" "this" {
  count            = var.create_random_password ? 1 : 0
  length           = var.random_password_length
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# 3. 仅存入纯密码字符串（或者如果你非要用 JSON，也可以只存 password 字段）
resource "aws_secretsmanager_secret_version" "this" {
  secret_id = aws_secretsmanager_secret.this.id
  secret_string = var.create_random_password ? random_password.this[0].result : var.secret_string

  lifecycle {
    ignore_changes = [secret_string]
  }
}

# 4. 允许自定义 IAM role 读取
data "aws_iam_policy_document" "this" {
  count = length(var.allowed_iam_roles) > 0 ? 1 : 0
  statement {
    actions   = ["secretsmanager:GetSecretValue", "secretsmanager:DescribeSecret"]
    resources = [aws_secretsmanager_secret.this.arn]
    principals {
      type        = "AWS"
      identifiers = var.allowed_iam_roles
    }
  }
}

resource "aws_secretsmanager_secret_policy" "this" {
  count      = length(var.allowed_iam_roles) > 0 ? 1 : 0
  secret_arn = aws_secretsmanager_secret.this.arn
  policy     = data.aws_iam_policy_document.this[0].json
}