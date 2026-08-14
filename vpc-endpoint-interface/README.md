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
  vpc_id = "vpc-05d503abcd8268187"
  environment = "dev"
  service_name = "s3"
  region = "us-east-1"
  subnet_ids = [
    "subnet-056267a6e81fc6faa",
    "subnet-0d25e5e7ef76dd2a6",
    "subnet-01fb96adad85d21fc"
  ]
  security_group_ids = [ "sg-0a1d0645a4a7a38ed" ]
  private_dns_enabled = true
  dns_options = {
    dns_reocrd_ip_type = null
    private_dns_only_for_inbound_resolver_endpoint = false 
  }

  tags = {
    ManagedbyTerrafrom = "true"
  }
  depends_on = [ module.maxwell_dev_vpc_endpoint_gateway ]
  
}

```

Check the DNS resolve bucket url whether a private IP

```shell

dig maxwell-kite-2026520.s3.us-east-1.amazonaws.com

```

If in China， S3 bucket URL is:

https://maxwell-kite.s3.cn-north-1.amazonaws.com.cn


private_dns_only_for_inbound_resolver_endpoint = false 
取消对入站解析器的专属限制，让该 VPC 终端节点的私有 DNS 对整个 VPC 内部的所有资源（以及配置了相应 DNS 转发的本地网络）全面开放。
当你开启 private_dns_enabled = true 时，AWS 会自动在你的 VPC 内部创建一个私有托管区（Private Hosted Zone），让 VPC 内的 EC2 实例在访问服务（如 S3、SQS）时，能够通过默认的 AWS DNS（169.254.16.2）直接解析到该接口终端节点的私有 IP 上。



