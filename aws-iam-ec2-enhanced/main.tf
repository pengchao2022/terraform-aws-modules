data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# 1. 创建 IAM Role
resource "aws_iam_role" "ec2_s3_role" {
  name_prefix = "${var.project_name}-${var.environment}-ec2-role-"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# 2. S3 权限（动态判断：只有传入了 bucket_names 时才创建此 Policy，现已包含控制台列出所有桶权限）
resource "aws_iam_policy" "s3_access" {
  count       = length(var.bucket_names) > 0 ? 1 : 0
  name_prefix = "${var.project_name}-${var.environment}-s3-access-"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowListAllBucketsInConsole"
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketLocation"
        ]
        Resource = "*"
      },
      {
        Sid    = "AllowSpecificBucketsObjectsAccess"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket",
          "s3:PutObject"
        ]
        Resource = flatten([
          for name in var.bucket_names : [
            "arn:aws:s3:::${name}",
            "arn:aws:s3:::${name}/*"
          ]
        ])
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_attach" {
  count      = length(var.bucket_names) > 0 ? 1 : 0
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access[0].arn
}

# 3. KMS 权限（新增：如果该 EC2 需要读写加密 S3，支持传入可选的 kms_key_arns）
resource "aws_iam_policy" "kms_access" {
  count       = length(var.kms_key_arns) > 0 ? 1 : 0
  name_prefix = "${var.project_name}-${var.environment}-kms-access-"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = [
        "kms:Decrypt",
        "kms:Encrypt",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      Effect   = "Allow"
      Resource = var.kms_key_arns
    }]
  })
}

resource "aws_iam_role_policy_attachment" "kms_access_attach" {
  count      = length(var.kms_key_arns) > 0 ? 1 : 0
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.kms_access[0].arn
}

# 4. SSM Read 权限
resource "aws_iam_policy" "ssm_read_policy" {
  name_prefix = "${var.project_name}-${var.environment}-ssm-"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["ssm:GetParameter"]
      Effect   = "Allow"
      Resource = "arn:aws:ssm:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:parameter/cw-agent/*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ssm_read_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.ssm_read_policy.arn
}

# 5. 托管策略绑定
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# 6. Instance Profile
resource "aws_iam_instance_profile" "this" {
  name_prefix = "${var.project_name}-${var.environment}-profile-"
  role        = aws_iam_role.ec2_s3_role.name
}

# 7. Secrets Manager 权限（新增：支持传入可选的 secret_arns 以读取凭据）
resource "aws_iam_policy" "secrets_access" {
  count       = length(var.secret_arns) > 0 ? 1 : 0
  name_prefix = "${var.project_name}-${var.environment}-secrets-access-"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowGetSecretValue"
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = var.secret_arns
      },
      # 如果你的 Secret 使用了自定义的 KMS Key 加密（而不是 AWS 默认的 aws/secretsmanager 密钥），
      # 通常还需要允许使用对应的 KMS 密钥进行解密。如果用的是默认密钥，此项非必须但加上更稳妥。
      {
        Sid    = "AllowDecryptSecretKMS"
        Effect = "Allow"
        Action = [
          "kms:Decrypt"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "kms:ViaService" = "secretsmanager.${data.aws_region.current.region}.amazonaws.com"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "secrets_access_attach" {
  count      = length(var.secret_arns) > 0 ? 1 : 0
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.secrets_access[0].arn
}