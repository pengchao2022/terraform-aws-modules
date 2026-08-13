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

If you just use for s3 and you can input the parameters directly

```shell

module "maxwell_dev_vpc_endpoint_gateway" {
  source   = "./modules/vpc-endpoint-gateway"

  region          = "us-east-1"
  service_name    = "s3"
  environment     = "prod"
  vpc_id          = module.maxwell_dev_vpc.vpc_id
  route_table_ids = ["rtb-0e34f1049f0be8395"]
}

```

Check the DNS whether resolve a private IP

```shell

dig maxwell-kite-2026520.s3.us-east-1.amazonaws.com

```






