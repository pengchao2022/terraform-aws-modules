## Function

perform as aws s3 bucket creation, you can use this module to create multiple s3 buckets

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

module "gopay-s3" {
  source = "./modules/aws-s3"
  bucket_name = "gopay-ec2-s3-01"
  force_destroy = true
  tags        = { Name = "gopay-s3" }

}

module "maxwell-s3" {
  source = "./modules/aws-s3"
  bucket_name = "maxwell-s3-for-kinesis"
  force_destroy = true
  tags        = { Name = "maxwell-s3" }

}

```

