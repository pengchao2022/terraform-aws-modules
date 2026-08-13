## Function

perform as aws two VPC transit gateway connection, By transit gateway the two VPC can communicate with each other

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

module "vpc_transit_gateway" {
  source = "./modules/vpc-transit-gateway"

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
      destination_cidrs = [
        "10.20.0.0/16",
        "10.50.0.0/16"
      ]
    },
    maxwell_prod_vpc = {
      vpc_id = module.maxwell_prod_vpc.vpc_id
      subnet_ids = module.maxwell_prod_vpc.private_subnet_ids 

      route_table_ids = concat(
        module.maxwell_prod_vpc.public_route_table_ids,
        module.maxwell_prod_vpc.private_route_table_ids
      )
      destination_cidrs = [
        "172.20.0.0/16",
        "10.50.0.0/16"
      ]
    },
    maxwell_int_vpc = {
      vpc_id = module.maxwell_int_vpc.vpc_id
      subnet_ids = module.maxwell_int_vpc.private_subnet_ids

      route_table_ids = concat(
        module.maxwell_int_vpc.public_route_table_ids,
        module.maxwell_int_vpc.private_route_table_ids
      )
      destination_cidrs = [
        "172.20.0.0/16",
        "10.20.0.0/16"
      ]
    }
  }
  tags = {
    Environment = "prod"
    Terraform   = "true"
  } 
}

```
If you don't have other vpc modules and you can also input parameters directly like this:

```shell


module "vpc_transit_gateway" {
  source = "./modules/vpc-transmit-gateway"

  name   = "maxwell-global"

  amazon_side_asn = 64512

  vpc_attachments = {
    maxwell_dev_vpc = {
      vpc_id = "vpc-06ccc4e20bbbe1e6c"
      # TGW ENI shoulbe be attached at  Private Subnet
      subnet_ids = [
        "subnet-0213c7a95a0618efd",
        "subnet-00a74494775faec7e",
        "subnet-06e6162357b34dde2"
      ]
      
      # shoube have public route tables and private route tables
      route_table_ids = [
        "rtb-0a067f028017cf237",
        "rtb-0653a4db111ceddd2"
      ]
      destination_cidr = "10.20.0.0/16"
    },

    maxwell_prod_vpc = {
      vpc_id = "vpc-073d89ab4bbb5b2b8"
      # shoube be private subnet for TGW ENI
      subnet_ids = [
        "subnet-089e9238f2dbf4e12",
        "subnet-0368b1285591f5135",
        "subnet-0430123f0cbc3e743"
      ]
       
      # shoube have public route tables and private route tables
      route_table_ids = [
        "rtb-0f82c6f95659e4bd6",
        "rtb-058f65702590129b5"
      ]
      destination_cidr = "172.20.0.0/16"
    }

  }
  tags = {
    Environment = "prod"
    Terraform   = "true"
  }
  
}

```

