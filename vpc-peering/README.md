## Function

perform as aws vpc peering, two vpcs can communicate with each other after peering.

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
module "gopay-vpc-peering-prod-to-dev" {
  source             = "./modules/vpc-peering"
  name               = "prod-to-dev"

  requester_vpc_id   = module.gopay-service-prod.vpc_id
  requester_vpc_cidr = "172.16.0.0/16"
  
  # conbine requester private and public route tables
  requester_route_table_ids = concat(
    module.gopay-service-prod.private_route_table_ids,
    module.gopay-service-prod.public_route_table_ids
  )

  accepter_vpc_id          = module.gopay-service-dev.vpc_id
  accepter_vpc_cidr        = "10.0.0.0/16"
  
  # conbine accepter private and public route tables
  accepter_route_table_ids = concat(
    module.gopay-service-dev.private_route_table_ids,
    module.gopay-service-dev.public_route_table_ids
  )

  accepter_region          = "us-east-1"
}
```
If you don't have other modules you want to combine route tables directly using like this:

```shell

module "maxwell-vpc-peering-prod-to-dev" {
  source             = "./modules/vpc-peering"
  name               = "prod-to-dev"

  requester_vpc_id   = "vpc-0b1c509509f2f9e95"
  requester_vpc_cidr = "10.20.0.0/16"
  
  # conbine requester private and public route tables
  requester_route_table_ids = [
    "rtb-0bf1a8cf3a93fae47",
    "rtb-017556c676b63e8ec",
    "rtb-04da3112ff718a9b9",
    "rtb-09ffc82103f89c34a"
  ]

  accepter_vpc_id          = "vpc-0ace4d20dbc6683d6"
  accepter_vpc_cidr        = "172.20.0.0/16"
  
  # conbine accepter private and public route tables
  accepter_route_table_ids = [
    "rtb-0299d79dcc6ac603d",
    "rtb-0f18d1264dcfd8ecf",
    "rtb-027d21984c9be6453",
    "rtb-0a645d215b5dc08de"
  ]

  accepter_region          = "us-east-1"
}
```
The aws cli command to get all the route tables in one VPC using like this:
```shell
aws ec2 describe-route-tables --filters "Name=vpc-id,Values=vpc-0ace4d20dbc6683d6" --query "RouteTables[?!(Associations[?Main==\`true\`])].{RouteTableId:RouteTableId, Name:Tags[?Key=='Name'].Value | [0]}" --output table

```


