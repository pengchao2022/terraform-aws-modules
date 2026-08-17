## Function

perform as aws s3 grant to IAM users permission with a CMK customer managed key arn

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

module "grant_existing_users_s3_cmk_access" {
  source = "./modules/aws-s3-to-iam-users-permission-with-kms-key"
  bucket_name = "maxwell-frontend-2009-cmk"

  kms_key_arn = "arn:aws:kms:us-east-1:317429619308:key/15360816-62be-4697-a173-8c2ecd91c915"

  iam_user_arns = [ 
    "arn:aws:iam::317429619308:user/wenwen.zhang"
  ]

}

```

