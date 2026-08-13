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
  source = "./modules/vpc-endpoint-interface"

  for_each            = toset(local.endpoint_services)
  environment         = "dev"
  vpc_endpoint_type   = "Interface"
  vpc_id              = module.gopay-vpc-dev.vpc_id
  service_name        = "com.amazonaws.${var.region}.${each.value}"
  subnet_ids          = module.gopay-vpc-dev.private_subnet_ids
  security_group_ids  = [module.gopay-vpc-dev.endpoint_security_group_id]
  private_dns_enabled = false
}

```

If you only want to create interface for s3 service and want the dns resolve private IP:

```shell


module "maxwell_dev_vpc_endpoint_interface" {
  source = "./modules/vpc-endpoint-interface"

  environment         = "dev"
  vpc_id              = module.maxwell_dev_vpc.vpc_id
  service_name        = "com.amazonaws.${var.region}.s3"
  subnet_ids          = module.maxwell_dev_vpc.private_subnet_ids
  security_group_ids  = [module.maxwell_dev_vpc.endpoint_security_group_id]
  private_dns_enabled = true
  dns_options = {
    private_dns_only_for_inbound_resolver_endpoint = false
    dns_record_ip_type                             = null # ipv4 by default
  }
  depends_on          = [ module.maxwell_dev_vpc_endpoint_gateway ]
}

```

Check the DNS resolve bucket url whether a private IP

```shell

dig maxwell-kite-2026520.s3.us-east-1.amazonaws.com

```



