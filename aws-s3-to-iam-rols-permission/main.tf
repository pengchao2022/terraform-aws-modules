# 引用现有的 S3 Bucket
data "aws_s3_bucket" "existing_bucket" {
  bucket = var.bucket_name
}

# 将传入的 Role ARN 列表映射成 { role_name = role_arn } 的结构
locals {
  role_map = {
    for arn in var.iam_role_arns : 
    element(split("/", arn), 1) => arn
  }
}

# 创建通用的 S3 访问策略
resource "aws_iam_policy" "bucket_access_policy" {
  name_prefix = "S3Access-EC2-"
  description = "IAM policy to allow access to bucket: ${var.bucket_name}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
      }
    ]
  })
}

# 使用 for_each 将策略附加给各个 Role
resource "aws_iam_role_policy_attachment" "attach_to_roles" {
  for_each = local.role_map

  # each.key 是解析出来的 role_name
  role       = each.key
  policy_arn = aws_iam_policy.bucket_access_policy.arn
}