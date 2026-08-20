# 获取当前的 AWS 账户 ID 和区域信息，用于精准生成 Key Policy
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# 定义标准安全的 Key Policy
data "aws_iam_policy_document" "kms_policy" {
  # 授予账户的根账号（Root）对该 KMS 密钥的完全管理权限（标准安全要求）
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  # 授权 AWS 服务（如 S3、CloudWatch Logs 等）在后台使用该密钥加密/解密
  statement {
    sid    = "Allow AWS Services to Use the Key"
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = [
        "s3.amazonaws.com",
        "logs.${data.aws_region.current.region}.amazonaws.com"
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}

# 创建 KMS 密钥
resource "aws_kms_key" "this" {
  description             = var.description
  deletion_window_in_days = var.deletion_window_in_days
  enable_key_rotation     = var.enable_key_rotation
  policy                  = data.aws_iam_policy_document.kms_policy.json

  tags = merge(
    { "Name" = var.alias_name },
    var.tags
  )
}

# 创建密钥别名（Alias），方便在后续的 S3 模块或资源中通过名字引用
resource "aws_kms_alias" "this" {
  name          = var.alias_name
  target_key_id = aws_kms_key.this.key_id
}