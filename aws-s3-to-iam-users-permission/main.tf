# 1. 引用现有的 S3 Bucket
data "aws_s3_bucket" "existing_bucket" {
  bucket = var.bucket_name
}

# 2. 为传入的每个用户单独生成一份 IAM 策略
# 我们用一个 local map 把 ARN 映射成 { user_name = user_arn } 的结构，方便循环
locals {
  user_map = {
    for arn in var.iam_user_arns : 
    element(split("/", arn), 1) => arn
  }
}

resource "aws_iam_policy" "bucket_access_policy" {

  # 使用 name_prefix 代替固定的 name
  # AWS 会自动在后面拼上随机字符，并且会智能裁剪以严格保证总长度不超过 64 个字符的限制
  name_prefix = "S3Access-"
  description = "Common IAM policy to allow S3 access for bucket: ${var.bucket_name}"

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
      }
    ]
  })
}

# 3. 将各自的策略附加给对应的 IAM 用户
resource "aws_iam_user_policy_attachment" "attach_to_users" {
  for_each = local.user_map

  user       = each.key
  policy_arn = aws_iam_policy.bucket_access_policy.arn
}