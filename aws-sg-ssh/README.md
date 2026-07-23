## Function

perform as aws ssh security group create for EC2 instance remote access

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

module "gopay_dev_web_server_ssh_sg" {
  source = "./modules/aws-sg-ssh"
  name   = "gopay-dev-web-server-ssh-sg"
  vpc_id = module.gopay-vpc-dev.vpc_id
  allowed_cidr_blocks = [ "0.0.0.0/0" ]
  tags = {
    Name = "gopay-dev-web-server-ssh-sg"
    Environment = "dev"
  }
}

```

