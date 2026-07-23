## Function

perform as aws iam group creation

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

locals {
  developers = ["alice", "bob", "eric", "kate"]
  admins     = ["maxwell", "lucy", "tim"]
  etws       = ["yongjun", "leo"]
}

module "admin_group" {
  source = "./modules/aws-iam-group"
  name   = "admin-team"
  users  = [for user in module.iam_users_admin : user.user_name]
  aws_managed_policies = {
    AdministratorAccess = "arn:aws:iam::aws:policy/AdministratorAccess"
  }
}

module "dev_group" {
  source = "./modules/aws-iam-group"
  name   = "dev-team"
  users  = [for user in module.iam_users_developer : user.user_name]
  aws_managed_policies = {
    ReadOnlyAccess = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
  # attach customer policies
  custom_policy_arns = {
    S3ReadOnly = module.s3_read_only_policy.arn
  }
  depends_on = [ 
    module.iam_users_developer,
    module.s3_read_only_policy
  ]
}

module "etw_group" {
  source = "./modules/aws-iam-group"
  name   = "etw-team"
  users  = [for user in module.iam_users_etw : user.user_name]
  aws_managed_policies = {
    ReadOnlyAccess = "arn:aws:iam::aws:policy/ReadOnlyAccess"
  }
  custom_policy_arns = {
    S3ReadOnly = module.s3_read_only_policy.arn
  }
  depends_on = [ 
    module.iam_users_etw,
    module.s3_read_only_policy
 ]
}

```

