## Function

perform as aws RDS creation

- the db password will from aws secrets manager random password

- the auth we will enable Iam_database_authentication 

- user can still use the username and password to login RDS 

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

module "web_server_dev_db" {
  source         = "./modules/aws-rds"
  identifier     = "web-server-dev-db-instance"
  engine         = "mysql"
  engine_version = "8.0.45"
  instance_class = "db.t3.micro"
  allocated_storage = 20
  max_allocated_storage = 100
  backup_retention_period = 0
  backup_window = "01:00-02:00"
  
  username          = "maxwell2026"
  password          = module.gopay_rds_dev_password.password # password form aws secrets manager 

  iam_database_authentication_enabled = true # enable rds iam database authentication 
  
  replica_count = 0

  db_subnet_group_name = module.gopay_dev_db_subnet_group.db_subnet_group_id

  vpc_security_group_ids = [ 
    module.web_server_dev_sg_mysql.security_group_mysql_id
  ]
  
  tags = {
    Name        = "web-server-dev-db"
    Environment = "dev"
  }
}

```
Create the iam user for the RDS which will no need password when connect to RDS

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




