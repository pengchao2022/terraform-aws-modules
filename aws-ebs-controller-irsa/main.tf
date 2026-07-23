data "aws_caller_identity" "current" {}

locals {
  # remove https prefix 
  clean_oidc_url = replace(var.cluster_oidc_issuer_url, "https://", "")
}

# assume role policy 
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/${local.clean_oidc_url}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.clean_oidc_url}:sub"
      values   = ["system:serviceaccount:${var.namespace}:${var.service_account_name}"]
    }

    condition {
      test     = "StringEquals"
      variable = "${local.clean_oidc_url}:aud"
      values   = ["sts.amazonaws.com"]
    }
  }
}

# create IAM role
resource "aws_iam_role" "this" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

# attach official policy
resource "aws_iam_role_policy_attachment" "this" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
}