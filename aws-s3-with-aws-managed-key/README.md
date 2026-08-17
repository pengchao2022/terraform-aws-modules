## Function

perform as aws s3 with AWS managed key 

- kms enabled
- bucket versioning enabled

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


module "maxwell_s3_with_aws_managed_key" {
  source = "./modules/aws-s3-with-aws-managed-key"
  bucket_name = "maxwell-fronted-008"
  force_destroy = true
  enable_versioning = true
  tags = {
    Lbu = "pacs"
    Environment = "prod"
  }
}


```

