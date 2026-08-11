# 动态获取当前的 AWS Account ID 和 Region，避免硬编码 arn:aws:ssm:region:account-id
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# 创建 IAM Role (移除了冲突的 name，改用 name_prefix 或包含 environment 的 name)
resource "aws_iam_role" "ec2_s3_role" {
  name_prefix = "${var.project_name}-${var.environment}-ec2-s3-role-"
  
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

# S3 权限 (推荐使用独立 Policy + Attachment，方便依赖清理)
resource "aws_iam_policy" "s3_access" {
  name_prefix = "${var.project_name}-${var.environment}-s3-access-"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = ["s3:GetObject", "s3:ListBucket", "s3:PutObject"]
      Effect = "Allow"
      Resource = flatten([
        for name in var.bucket_names : [
          "arn:aws:s3:::${name}",
          "arn:aws:s3:::${name}/*"
        ]
      ])
    }]
  })
}

resource "aws_iam_role_policy_attachment" "s3_access_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

# SSM Read 权限 (使用动态 data 获取真实的 account_id 和 region)
resource "aws_iam_policy" "ssm_read_policy" {
  name_prefix = "${var.project_name}-${var.environment}-ssm-cw-"

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

# 托管策略绑定 (CloudWatch & ECR)
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ecr_readonly_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Instance Profile (name_prefix，解决多环境/多实例冲突)
resource "aws_iam_instance_profile" "this" {
  name_prefix = "${var.project_name}-${var.environment}-instance-profile-"
  role        = aws_iam_role.ec2_s3_role.name
}