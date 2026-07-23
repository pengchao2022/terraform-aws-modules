resource "aws_iam_group" "this" {
  name      = var.name
}

# 关联用户到组
resource "aws_iam_group_membership" "this" {
  count     = length(var.users) > 0 ? 1 : 0
  name      = "${var.name}-membership"
  users     = var.users
  group     = aws_iam_group.this.name
}

# 附加AWS 托管策略
resource "aws_iam_group_policy_attachment" "managed" {
  for_each   = var.aws_managed_policies
  group      = aws_iam_group.this.name
  policy_arn = each.value
}

# 附加自定义策略
resource "aws_iam_group_policy_attachment" "custom" {
  for_each   = var.custom_policy_arns
  group      = aws_iam_group.this.name
  policy_arn = each.value
}
