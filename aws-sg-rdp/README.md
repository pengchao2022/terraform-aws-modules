## Function

perform as aws RDP security group creation

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

module "web_server_dev_rdp" {
  source = "./modules/aws-sg-rdp"
  name   = "web-server-dev-rdp"
  vpc_id = module.maxwell_vpc_dev.vpc_id
  allowed_cidr_blocks = [ "0.0.0.0/0" ]
  tags = {
    Name = "web-server-dev-rdp-sg"
    Environment = "dev"
  }
}

```

