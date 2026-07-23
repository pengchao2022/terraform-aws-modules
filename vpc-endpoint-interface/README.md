## Function

perform as aws vpc endpoint interface, and will including several aws services like

- aws s3
- aws ecr.api
- ecr.dkr
- logs
- ssm
- ssmmessages
- eks
- sts
- secretsmanager


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
please write the locals variable on the top of you called main.tf file

```shell

locals {
  endpoint_services = [
    "s3",
    "ecr.api",
    "ecr.dkr",
    "logs",
    "ssm",
    "ssmmessages",
    "eks",
    "sts",
    "secretsmanager"
  ]
}

module "gopay-vpc-dev-endpoint-interface" {
  source = "./modules/vpc-endpoint"

  for_each     = toset(local.endpoint_services)
  environment  = "dev"
  vpc_endpoint_type = "Interface"
  vpc_id            = module.gopay-service-dev.vpc_id
  service_name      = "com.amazonaws.${var.region}.${each.value}"
  subnet_ids          = module.gopay-service-dev.private_subnet_ids
  security_group_ids  = [module.gopay-service-dev.endpoint_security_group_id]
  private_dns_enabled = false
}

```


