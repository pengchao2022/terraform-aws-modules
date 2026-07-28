## Function

perform as aws db subnet group creation, you can use this module when you prepare to create AWS RDS.

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


module "maxwell_prod_db_subnet_group" {
  source      = "./modules/db-subnet-group"
  name        = "maxwell-prod-db-subnet-group"
  description = "maxwell prod db subnets group created by Terraform"
  subnet_ids  = module.maxwell_dev_vpc.private_subnet_ids
  tags = {
    Name = "maxwell-prod-db-subnet-group"
    Environment = "prod"
  }
}

```

