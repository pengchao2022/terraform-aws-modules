## Function

perform as aws rds database creation, you can create the RDS mysql or postgresql usging this module

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


module "maxwell_prod_db" {
  source = "./modules/aws-rds"
  identifier = "maxwell-prod-db-instance"
  engine     = "mysql"
  engine_version = "8.0.45"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  max_allocated_storage = 100
  backup_retention_period = 1 # free trail does not support backup
  backup_window = "01:00-02:00"

  replica_count = 2 # free trail does not support replica

  username          = "maxwell2026prod"
  password          = module.maxwell_rds_dev_password.password

  iam_database_authentication_enabled = true

  db_subnet_group_name = module.maxwell_prod_db_subnet_group.db_subnet_group_id

  vpc_security_group_ids = [ 
    module.maxwell_prod_sg_mysql.security_group_mysql_id
  ]
  tags = {
    Name        = "maxwell-prod-db"
    Environment = "prod"
  }
}

```

