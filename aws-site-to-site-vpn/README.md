## Function

perform as aws site to site VPN with tgw and client VPN creation.

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

module "maxwell_site_to_site_vpn_prod" {
  source = "./modules/aws-site-to-site-vpn-tgw"

  transit_gateway_id = module.vpc_transit_gateway.ec2_transit_gateway_id
  tgw_route_table_id = module.vpc_transit_gateway.transit_gateway_route_table_id

  name_prefix = "maxwell-vpn"
  client_common_name = "maxwell-shared-client"
  organization_name  = "maxwell-corp"
  customer_public_ip = "120.231.213.197"
  s2s_local_subnet_cidr = "192.168.100.0/24"
  vpc_cidr_block = "10.20.0.0/16"
  target_subnet_ids = module.maxwell_prod_vpc.private_subnet_ids

  tags = {
    Environment = "prod"
    ManagedBy   = "terraform"
    Project     = "hybrid-cloud"
    Owner       = "maxwell"
  }
}

```


Get your laptop public IP
```shell

curl -4 myip.ipip.net

```

