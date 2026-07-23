## Function

perform as aws ECS cluster creation

compare with AWS EKS

- ECS task definition   --- kubernetes Pod template

- ECS task              --- kubernetes Pod

- ECS service           --- kubernetes Deployment 


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

module "gopay_frontend_ecs_service" {
  source = "./modules/aws-ecs"

  cluster_name    = "gopay-prod-ecs-cluster"
  service_name    = "gopay-frontend-service"
  container_name  = "gopay-frontend"
  container_image = "317429619308.dkr.ecr.us-east-1.amazonaws.com/gopay-frontend:9.0.0"
  container_port  = 80
  health_check_port = 80 
  log_retention_days = 14

  vpc_id          = module.gopay-service-prod.vpc_id
  subnet_ids      = module.gopay-service-prod.private_subnet_ids

  target_group_arn = module.gopay_ecs_alb.frontend_target_group_arn

  lb_security_group_id = module.gopay_ecs_alb.lb_security_group_id

}

module "gopay_backend_ecs_service" {
  source = "./modules/aws-ecs"

  cluster_name    = "gopay-prod-ecs-cluster"
  service_name    = "gopay-backend-service"
  container_name  = "gopay-backend"
  container_image = "317429619308.dkr.ecr.us-east-1.amazonaws.com/gopay-backend:8.0.0"
  container_port  = 8000
  health_check_port = 8000
  log_retention_days = 14

  vpc_id          = module.gopay-service-prod.vpc_id
  subnet_ids      = module.gopay-service-prod.private_subnet_ids
  rds_instance_id = "db-QB6JMKEE7JCECJP7HUTYNT755M"
  db_iam_user     = "iam_gopay_user"

  environment_variables = [
  { name = "DB_HOST", value = "web-server-prod-db-instance.c6jyq0ka0zqf.us-east-1.rds.amazonaws.com" },
  { name = "DB_PORT", value = "3306" },
  { name = "DB_NAME", value = "gopay_web_db" },
  { name = "DB_USER", value = "iam_gopay_user" } 
]

  target_group_arn = module.gopay_ecs_alb.backend_target_group_arn
  lb_security_group_id = module.gopay_ecs_alb.lb_security_group_id

}

```

This ECS depends ECS Alb and for the rds part we use the IAM role instead of db password

```shell

# install mysql client
sudo apt update
sudo apt install mysql-client -y

# connect to rds mysql server
mysql -h web-server-prod-db-instance.c6jyq0ka0zqf.us-east-1.rds.amazonaws.com -P 3306 -u maxwell2026prod -p

CREATE DATABASE IF NOT EXISTS gopay_web_db;

CREATE USER 'iam_gopay_user' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';


CREATE USER 'iam_gopay_user' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';
GRANT SELECT, INSERT, UPDATE, DELETE ON gopay_web_db.* TO 'iam_gopay_user';
FLUSH PRIVILEGES;

# grant iam user create tables privilidge
GRANT ALL PRIVILEGES ON gopay_web_db.* TO 'iam_gopay_user'@'%';

# refresh and apply changes
FLUSH PRIVILEGES;

# full operation step for your refrence
ubuntu@ip-172-16-10-48:~$ mysql -h web-server-prod-db-instance.c6jyq0ka0zqf.us-east-1.rds.amazonaws.com -P 3306 -u maxwell2026prod -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 25
Server version: 8.0.45 Source distribution

Copyright (c) 2000, 2026, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> CREATE DATABASE IF NOT EXISTS gopay_web_db;
Query OK, 1 row affected, 1 warning (0.04 sec)

mysql> CREATE USER 'iam_gopay_user' IDENTIFIED WITH AWSAuthenticationPlugin AS 'RDS';
Query OK, 0 rows affected (0.21 sec)

mysql> GRANT SELECT, INSERT, UPDATE, DELETE ON gopay_web_db.* TO 'iam_gopay_user';
Query OK, 0 rows affected (0.07 sec)

mysql> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.06 sec)

mysql> 
####

```




