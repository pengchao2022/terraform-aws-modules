## Function

perform as aws mysql security group creation

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

module "web_server_dev_sg_mysql" {
  source = "./modules/aws-sg-mysql"
  name   = "web-server-dev-mysql-sg"
  vpc_id = module.maxwell_vpc_dev.vpc_id
  allowed_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  allowed_security_group_ids = [
    module.web_server_dev_http_8080_sg.security_group_http_8080_id,
    module.web_server_dev_http_sg.security_group_http_id,
    module.web_server_dev_https_sg.security_group_https_id
  ]
  tags = {
    Name = "web-server-dev-sql-sg"
    Environment = "dev"
  }
}

```

