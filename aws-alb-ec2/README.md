## Function

perform as aws prodution alb creation which target group is EC2 instances

this module needs SSL certificate which allow HTTPS and all the HTTP will be redirect to HTTPS

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

module "maxwell_web_ec2_alb" {

  source = "./modules/aws-alb-ec2"

  project_name = "maxwell-web-dev"

  vpc_id       = module.maxwell_prod_vpc.vpc_id

  subnet_ids   = module.maxwell_prod_vpc.public_subnet_ids

  target_port  = 80

  health_check_path = "/"

  enable_deletion_protection = false 

  acm_certificate_arn = module.maxwell_web_acm.certificate_arn


  # use the values() function then transfer map to list
  ec2_targets = module.maxwell-ec2-prod.instance_ids

  tags = {
    Environment = "prod"
  }
}

```

please be noticed if you are using a SSL cert from Tecent cloud or Alibaba cloud, then you can still 

use this module , you need to upload your third party SSL cert to AWS IAM , then you will get a AWS 

ARN for the third party SSL cert , then for the "acm_certificate_arn" variable , just use that ARN



