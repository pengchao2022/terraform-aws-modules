resource "aws_organizations_policy" "data_perimeter_rcp" {
  name        = "EnterpriseDataPerimeterRCP"
  description = "Ensures that resources within the organization cannot be accessed by external entities outside the trusted org."
  type        = "RESOURCE_CONTROL_POLICY"

  content = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "DenyExternalAccessToOrganizationResources"
        Effect = "Deny"
        Principal = "*"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "kms:Decrypt",
          "kms:ReEncrypt*"
        ]
        Resource = "*"
        Condition = {
          StringNotEquals = {
            # 限制请求必须来自指定的 AWS 组织
            "aws:PrincipalOrgID" = var.trusted_org_id
          },
          ArnNotLike = {
            # 放行一些合法的 AWS 内部服务角色（按需添加）
            "aws:PrincipalArn" = [
              "arn:aws:iam::*:role/aws-service-role/s3.amazonaws.com/*",
              "arn:aws:iam::*:role/aws-service-role/cloudtrail.amazonaws.com/*"
            ]
          }
        }
      }
    ]
  })
}

# 将 RCP 绑定到指定的根节点、OU 或账号
resource "aws_organizations_policy_attachment" "rcp_attachment" {
  policy_id = aws_organizations_policy.data_perimeter_rcp.id
  target_id = var.target_id
}