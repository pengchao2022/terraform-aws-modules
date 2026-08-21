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
    actions = [ "sts:AssumeRoleWithWebIdentity" ]
    principals {
      type        = "Federated"
      identifiers = [ module.github_oidc.arn ]   # call the arn created by module github oidc provider
    }

    condition {
      test      = "StringLike"
      variable  = "token.actions.githubusercontent.com:sub"
      values    = ["repo:pengchao2022/*"]
      # if you wnat to set only main branch can call AWS API to deploy resources
      # values   = ["repo:pengchao2022/*:ref:refs/heads/main"]
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

