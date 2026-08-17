## Function

perform as aws Customer Managed Keys creation 

- CMK creation

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

module "maxwell_kms_cmk_frontend" {
  source = "./modules/aws-kms-cmk"
  description = "KMS CMK for production s3"
  alias_name  = "alias/prod-s3-custom-key-01"
  deletion_window_in_days = 30
  enable_key_rotation     = true
  tags = {
    Environment = "production"
    Project     = "infrastructure"
    Terraform   = "true"
  }
}

```

