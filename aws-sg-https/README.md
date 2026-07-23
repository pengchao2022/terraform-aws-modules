## Function

perform as aws https security group creation

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

module "web_server_dev_https_sg" {
  source = "./modules/aws-sg-https"
  name   = "web-server-dev-https-sg"
  vpc_id = module.maxwell_vpc_dev.vpc_id
  allowed_cidr_blocks = [ "10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24" ]
  tags = {
    Name        = "web-server-dev-https-sg"
    Environment = "dev"
  }
}

```

