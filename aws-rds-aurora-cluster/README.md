## Function

perform as aws rds aurora cluster creation. 

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


module "maxwell_dev_rds_aurora_cluster" {
  source = "./modules/aws-rds-aurora"

  name                 = "maxwell-dev-aurora-cluster"
  database_name        = "maxwelldb"
  username             = "maxwell2026aurora"
  password             = module.maxwell_rds_dev_password.password

  iam_database_authentication_enabled = true

  db_subnet_group_name = module.maxwell_prod_db_subnet_group.db_subnet_group_id

  vpc_security_group_ids = [ 
    module.maxwell_prod_sg_mysql.security_group_mysql_id
  ]

  engine                  = "aurora-mysql" 
  engine_version          = "8.0.mysql_aurora.3.08.2"
  instance_count          = 3
  instance_class          = "db.t4g.medium"

  tags = {
    Name = "maxwell-dev-aurora-cluster"
    Environment = "dev"
  }
}


```

