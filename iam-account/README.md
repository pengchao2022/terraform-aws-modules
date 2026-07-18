## Function

perform as aws account policy, here you can set the account and password policy

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

download this module in your lcoal directory and call this module like this:

```shell
module "iam_account" {
  source = "./modules/iam-account"

  account_alias             = "gopay-prod-env"
  minimum_password_length   = 12
  max_password_age          = 90
  password_reuse_prevention = 5 
}

```

