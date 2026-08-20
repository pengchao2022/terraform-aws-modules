## Function

perform as aws iam role for EC2 , enhanced means you can create a base iam role with no buckets or policies

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

module "maxwell_ec2_iam_role_kms_dev" {
  source = "./modules/aws-iam-ec2-enhanced"
  project_name = "maxwell-web-app-test-kms"
  environment = "dev"
}

```

For AWS secretsmanager supported

```shell

module "maxwell_ec2_iam_role_with_rabbit_secret" {
  source = "./modules/aws-iam-ec2-enhanced"
  project_name = "maxwell-microservices"
  environment = "dev"
  secret_arns = [
    "arn:aws:secretsmanager:us-east-1:317429619308:secret:secret-for-rabbitmq-int-FRCr5D"
  ]
}

```

