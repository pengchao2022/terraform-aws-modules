resource "aws_iam_role" "this" {
  name                  = var.name
  description           = var.description
  assume_role_policy    = var.assume_role_policy_json
  tags                  = var.tags 
}

# attach aws managed policy or custom policy
resource "aws_iam_role_policy_attachment" "attachments" {
  for_each      = var.policy_arns
  role          = aws_iam_role.this.name
  policy_arn    = each.value
}

# attach inline policy
resource "aws_iam_role_policy" "inline" {
  # count  = var.inline_policy_json != null ? 1 : 0
  name   = "${var.name}-inline-policy"
  role   = aws_iam_role.this.id
  policy = var.inline_policy_json != null ? var.inline_policy_json : jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["sts:AssumeRole"] 
      Resource = "*"
      Condition = {
        StringEquals = { "aws:PrincipalTag/dummy" = "true" }
      }
    }]
  })
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.name
  role  = aws_iam_role.this.name
}



