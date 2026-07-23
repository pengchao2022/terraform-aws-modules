## Function

perform as aws random password creation 

for example here we create password for RDS


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

module "gopay_rds_dev_password" {
  source                 = "./modules/aws-secrets-manager"
  name                   = "gopay-rds-dev-password-v1"
  description            = "RDS Dev Master password"
  create_random_password = true
  random_password_length = 40
  kms_key_id             = module.db_kms_key.key_arn
}


```

