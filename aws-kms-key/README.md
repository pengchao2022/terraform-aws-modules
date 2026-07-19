## Function

perform as aws kms key creation, you can use this module to create kms keys

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

module "db_kms_key" {
  source      = "./modules/aws-kms-key"
  name        = "gopay-rds-key"
  description = "KMS key for GoPay Secrets"
  allowed_iam_role_arns = [module.lambda_role.arn]
}


```

