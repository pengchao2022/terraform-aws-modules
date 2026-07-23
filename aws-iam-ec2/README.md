## Function

perform as aws ec2 iam role collection will output instance profile name which can be attached to EC2 instance 

This module will give EC2 access to :

- aws ecr readonly

- aws s3 readonly

- aws cloudwatch to collect ec2 logs and send to aws cloudwatch loggroup


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

module "maxwell-ec2-iam" {
  source = "./modules/aws-iam-ec2"
  project_name = "gopay-service"
  bucket_names = [ 
    module.gopay-s3.bucket_name,
    module.maxwell-s3.bucket_name
   ]
}

```

