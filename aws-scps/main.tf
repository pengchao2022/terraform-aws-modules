# 策略一：禁止删除 CloudTrail 日志与配置
resource "aws_organizations_policy" "protect_cloudtrail" {
  name        = "ProtectCloudTrail"
  description = "Prevents tampering or deletion of CloudTrail and related S3/IAM resources."
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyCloudTrailTampering"
        Effect    = "Deny"
        Action = [
          "cloudtrail:DeleteTrail",
          "cloudtrail:StopLogging",
          "cloudtrail:UpdateTrail",
          "cloudtrail:PutEventSelectors"
        ]
        Resource = "*"
      }
    ]
  })
}

# 策略二：区域白名单限制 (Region Lock)
resource "aws_organizations_policy" "region_restriction" {
  name        = "RegionRestriction"
  description = "Restricts resource creation to specified allowed AWS regions only."
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "DenyAllExceptAllowedRegions"
        Effect    = "Deny"
        NotAction = [
          # 全局服务（IAM, Route53, CloudFront 等）必须放行，否则控制台和全局命令会瘫痪
          "iam:*",
          "route53:*",
          "route53domains:*",
          "cloudfront:*",
          "support:*",
          "sts:",
          "wellarchitected:*"
        ]
        Resource = "*"
        Condition = {
          StringNotEquals = {
            "aws:RequestedRegion" = [
              "us-east-1",     # 允许的区域 1
              "ap-southeast-1" # 允许的区域 2 (例如新加坡，可按需修改)
            ]
          }
        }
      }
    ]
  })
}


# 3. 策略三：防止破坏性操作与账号自毁
resource "aws_organizations_policy" "prevent_destructive_actions" {
  name        = "PreventDestructiveActions"
  description = "Prevents account self-deletion, critical network teardowns, and S3 destruction."
  type        = "SERVICE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyAccountLeaveOrDelete"
        Effect = "Deny"
        Action = [
          "organizations:LeaveOrganization",
          "account:DeleteAccount"
        ]
        Resource = "*"
      },
      {
        Sid    = "DenyCoreInfrastructureDestruction"
        Effect = "Deny"
        Action = [
          "ec2:DeleteVpc",
          "ec2:DeleteSubnet",
          "s3:DeleteBucket",
          "dynamodb:DeleteTable"
        ]
        Resource = "*"
      }
    ]
  })
}

# 策略绑定：将上述策略批量绑定到目标 OU (如 Development OU)
locals {
  policies = [
    aws_organizations_policy.protect_cloudtrail.id,
    aws_organizations_policy.region_restriction.id,
    aws_organizations_policy.prevent_destructive_actions.id
  ]
}

resource "aws_organizations_policy_attachment" "attachments" {
  count     = length(local.policies)
  policy_id = local.policies[count.index]
  target_id = var.target_id
}