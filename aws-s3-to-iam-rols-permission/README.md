## Function

perform as aws assign existing S3 access to existing IAM roles

- require existing S3 bucket 
- multiple existing IAM roles supported

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


module "s3_access_for_int_ec2" {
  source = "./modules/aws-s3-to-iam-rols-permission"
  bucket_name = "maxwell-frontend-007"
  iam_role_arns = [
    "arn:aws:iam::317429619308:role/maxwell-frontend-1-int-ec2-role-ecd6820cf00ee6da0e17da4327",
    "arn:aws:iam::317429619308:role/maxwell-web-app-test-kms-dev-ec2-role-424c4331e6b1dee96a3a5d22d0"
  ]
}


```

List the files from bucket:
```shell
aws s3 ls maxwell-frontend-007

```

Download the files from bucket:
```shell
aws s3 cp s3://maxwell-frontend-007/AWS_VPN_Client_ARM64.pkg .

```

Upload files to the bucket:
```shell
aws s3 cp hello2026.txt s3://maxwell-frontend-007

```

Create a folder in the S3 bucket
```shell
aws s3api put-object --bucket maxwell-frontend-007 --key new-folder-01

```







