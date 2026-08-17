## Function

perform as aws S3 bucket creation with Customer managed keys 

- CMK customer managed Keys kms_key_arn is needed


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


module "maxwell_secure_s3_with_cmk" {
  source = "./modules/aws-s3-with-customer-managed-key"
  bucket_name = "maxwell-frontend-2009-cmk"
  force_destroy = false
  enable_versioning = true
  kms_key_arn = "arn:aws:kms:us-east-1:317429619308:key/15360816-62be-4697-a173-8c2ecd91c915"
  tags = {
    Environment = "production"
    Project     = "infrastructure"
    Terraform   = "true"
  }
}

```

