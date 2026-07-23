## Function

perform as aws user creation, you can define locals write multiple users

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

locals{
  developers = ["alice", "bob", "eric", "kate"]
  admins     = ["maxwell", "lucy", "tim"]
  etws       = ["yongjun", "leo"]

}


module "iam_users_developer" {
  source = "./modules/aws-iam-user"
  for_each = toset(local.developers)
  name     = each.value
  create_access_key = true
}

module "iam_users_admin" {
  source = "./modules/iam-user"
  for_each = toset(local.admins)
  name     = each.value
  create_console_login = true
}

module "iam_users_etw" {
  source = "./modules/iam-user"
  for_each = toset(local.etws)
  name     = each.value
  create_access_key = true
}

```

