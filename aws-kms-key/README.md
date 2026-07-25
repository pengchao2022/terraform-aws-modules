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
  allowed_iam_role_arns = [module.lambda_role.arn] # if you do not have this role or user arn , you can remove this variable here
}

write like ths is also OKay

module "db_kms_key" {
  source      = "./modules/aws-kms-key"
  name        = "maxwell-rds-dev-key"
  description = "KMS key for GoPay Secrets"
}

```

For the allowed_iam_role_arn :

It supports both Iam role and Iam user

for example:

- Iam role: "arn:aws:iam::317429619308:role/rds-lambda-role"

- Iam user: "arn:aws:iam::317429619308:user/eric"

If you already have this kms key arn, and want to grant eric the access to decrypt the password

then you can also modify eric's IAM policy like this:

```shell

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:Decrypt",
                "kms:GenerateDataKey*"
            ],
            # here write the kms key arn
            "Resource": "arn:aws:kms:us-east-1:317429619308:key/cb67fc5a-4d3a-48f2-9f82-2c9f19caaaf6"
        }
    ]
}

```



