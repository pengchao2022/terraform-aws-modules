## Function

perform as aws cloudwatch logs mornitoring

Td reduce cost In a real production environment we will do some optimization for cloudwatch log  management 

- for the network we will only collect the REJECT traffic logs

- for the storage we will use kiness firehose to migrate logs to S3 Anytime

- for the keep logs days we will set for 7 days in cloudwatch 

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

module "gopay-vpc-dev-logs" {
  source = "./modules/aws-cloudwatch"

  count = 1
  
  log_group_name      = "/aws/vpc/gopay-dev-flow-logs"
  retention_in_days   = 7
  vpc_id              = module.gopay-service-dev.vpc_id
  # if you already actived aws kinesis then you can export logs to s3 using kinesis
  # archive_s3_bucket_arn = module.gopay-s3.bucket_arn
  archive_s3_bucket_arn = null

  tags = {
    Environment = "dev"
    Project     = "gopay-service"
    ManagedBy   = "Terraform"
  }
  
  depends_on = [
    module.gopay-vpc-dev,
    module.gopay-s3
  ]
}

```

