## Function

perform as aws Organization SCPs creation, SCP is short for Service Control Policies.

It works like safety guardrail - 安全护栏

In this module, the SCP will do the following things

- ProtectCloudTrail

- RegionRestriction

- PreventDestructiveActions

    - 禁止删除 VPC (ec2:DeleteVpc) 和子网 (ec2:DeleteSubnet)
    - 禁止删除 S3 存储桶 (s3:DeleteBucket)
    - 禁止删除 DynamoDB 表 (dynamodb:DeleteTable)

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


module "development_guardrails" {
  source = "./modules/aws-scps"

  # 将安全护栏绑定之前创建的 Development OU
  target_id = "ou-9nci-yaoobo6x"
}

```

For different OUs , you can apply different SCPs





