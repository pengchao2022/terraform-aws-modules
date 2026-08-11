## Function

perform as aws two VPC transmit gateway connection, By transmit gateway the two VPC can communicate with each other

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

module "vpc_transmit_gateway" {
  source = "./modules/vpc-transmit-gateway"

  name   = "maxwell-global"

  amazon_side_asn = 64512

  vpc_attachments = {
    maxwell_dev_vpc = {
      vpc_id = module.maxwell_dev_vpc.vpc_id
      subnet_ids = module.maxwell_dev_vpc.private_subnet_ids # TGW ENI shoulbe be attached at  Private Subnet
      
      route_table_ids = concat(
        module.maxwell_dev_vpc.public_route_table_ids,
        module.maxwell_dev_vpc.private_route_table_ids
      )
      destination_cidr = "10.20.0.0/16"
    },

    maxwell_prod_vpc = {
      vpc_id = module.maxwell_prod_vpc.vpc_id
      subnet_ids = module.maxwell_prod_vpc.private_subnet_ids 

      route_table_ids = concat(
        module.maxwell_prod_vpc.public_route_table_ids,
        module.maxwell_prod_vpc.private_route_table_ids
      )
      destination_cidr = "172.20.0.0/16"
    }

  }
  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
  
}


```

