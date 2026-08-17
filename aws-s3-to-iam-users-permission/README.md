## Function

perform as aws assign existing S3 access to existing IAM Users

- require existing S3 bucket 
- multiple existing IAM users supported
- multiple IAM users share one Policy

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


module "grant_exist_users_s3" {
  source = "./modules/aws-s3-to-iam-users-permission"
  bucket_name = "amazon-s3-for-sophia"
  iam_user_arns = [
    "arn:aws:iam::317429619308:user/sophia.zhao",
    "arn:aws:iam::317429619308:user/meijing.li"
  ]
}

```



