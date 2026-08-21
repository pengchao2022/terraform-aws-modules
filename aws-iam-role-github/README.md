## Function

perform as aws github action IAM role creation, will ceate an IAM role so that Github CI can deploy AWS resources

## Usage

### Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.7 |
| aws | >= 6.28 |

### Providers

| Name | Version |
|------|---------|
| aws | >= 6.28 |


### Deploy

download this module in your lcoal directory and call this module like this:

```shell

# define OIDC trust policy
data "aws_iam_policy_document" "github_oidc_assume" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [module.github_oidc.arn]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      # 使用通配符兼容所有仓库的新版 ID 格式
      # repo:组织名@组织ID/仓库名@仓库ID:ref:refs/heads/*
      values = [
        "repo:pengchao2022@*/*:ref:refs/heads/*",
        "repo:pengchao2022/*:ref:refs/heads/*"
      ]
    }
  }
}

module "github_workflow_full_manage_role" {
  source = "./modules/aws-iam-role"
  name = "github_actions_role"
  # using the federated json
  assume_role_policy_json = data.aws_iam_policy_document.github_oidc_assume.json

  policy_arns = {
    # give admin access which allows github to create all the aws resources
    AdminAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
}

```

will retun an arn which will be used in github actions secrects named AWS_ROLE_ARN

