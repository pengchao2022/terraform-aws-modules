## Function

perform as aws rabbitmq security group creation

- rabbitmq cluster supported
- rabbitmq standard alone supported

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

module "maxwell_rabbitmq_sq_cluster" {
  source = "./modules/sg-rabbitMQ"
  vpc_id = module.maxwell_dev_vpc.vpc_id
  allowed_admin_cidr_blocks = [
    "172.20.0.0/16"
  ]
  allowed_cidr_blocks = [
    "172.20.0.0/16"
  ]
  environment = "dev-cluster"
}

```

If you want to access via internet call like this:

```shell

module "maxwell_rabbitmq_sq_standard_alone" {
  source = "./modules/sg-rabbitMQ"
  vpc_id = module.maxwell_dev_vpc.vpc_id
  allowed_admin_cidr_blocks = [
    "0.0.0.0/0"
  ]
  allowed_cidr_blocks = [
    "172.20.0.0/16"
  ]
  environment = "dev-alone"
}

```

