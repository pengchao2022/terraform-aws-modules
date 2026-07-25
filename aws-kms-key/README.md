## Function

perform as aws kms key creation, you can use this module to create kms key , then use the kms_key_id for decryption

note:

kms key id is for decrytion , It's not for encryption , since mostly encreption is AWS default action , no need to declare.

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

