## Function

perform as write aws custom policy, this policy can be attched to roles or users

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
module "s3_read_only_policy" {
  source = "./modules/aws-iam-policy"
  name   = "gopay-s3-readonly-policy"
  description = "Allow read-only access to gopay buckets"

  policy_json = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      { 
        Sid    = "AllowReadS3"
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*"
        ]
        Resource = [
          module.gopay-s3.bucket_arn,
          "${module.gopay-s3.bucket_arn}/*"
        ]
      }
    ]
  })
}

```

