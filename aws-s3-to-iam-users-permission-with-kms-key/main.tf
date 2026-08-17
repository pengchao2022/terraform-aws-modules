# 1. 引用现有的 S3 存储桶以获取其 ARN
data "aws_s3_bucket" "existing_bucket" {
  bucket = var.bucket_name
}

# 2. 将传入的 IAM 用户 ARN 列表转换为以用户名为 Key、ARN 为 Value 的 Map
# 用于 for_each 循环，确保即使列表顺序改变也不会触发意外的资源重建
locals {
  user_map = {
    for arn in var.iam_user_arns : 
    element(split("/", arn), 1) => arn
  }
}

# 3. 创建内含 S3 权限以及 CMK 加解密权限的统一 IAM 策略
resource "aws_iam_policy" "bucket_cmk_access_policy" {
  name_prefix = "S3CMKAccess-"
  description = "Standard policy granting S3 read/write and CMK encrypt/decrypt access for bucket: ${var.bucket_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowConsoleListAllMyBuckets",
        Effect = "Allow",
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ],
        Resource = "*"
      },
      {
        Sid    = "AllowListExistingBucket",
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = [data.aws_s3_bucket.existing_bucket.arn]
      },
      {
        Sid    = "AllowObjectReadWrite",
        Effect = "Allow",
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
        Resource = ["${data.aws_s3_bucket.existing_bucket.arn}/*"]
      },
      {
        Sid    = "AllowCMKEncryptionDecryption",
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:Encrypt",
          "kms:ReEncrypt*",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ],
        Resource = [var.kms_key_arn]
      }
    ]
  })
}

# 4. 循环将该策略附加给每一个指定的 IAM 用户
resource "aws_iam_user_policy_attachment" "attach_to_users" {
  for_each = local.user_map

  user       = each.key
  policy_arn = aws_iam_policy.bucket_cmk_access_policy.arn
}