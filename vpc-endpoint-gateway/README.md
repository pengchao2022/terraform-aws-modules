## Function

perform as aws vpc endpoint gateway service

the endpoint gateway type support two kinds of aws service:

- aws s3

- aws dynamodb


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

module "gopay_eks_prod_endpoint_gateway" {
  source   = "./modules/vpc-endpoint-gateway"

  region          = var.region
  service_name    = "s3"
  environment     = "prod"
  vpc_id          = module.gopay_eks_prod_vpc.vpc_id
  route_table_ids = module.gopay_eks_prod_vpc.private_route_table_ids
}

```

