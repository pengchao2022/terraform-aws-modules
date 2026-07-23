## Function

perform as aws icmp security group creation

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

module "maxwell_ec2_dev_icmp_sg" {
  source = "./modules/aws-sg-icmp"
  name   = "maxwell-ec2-icmp-dev-sg"
  vpc_id = module.maxwell_dev_vpc.vpc_id
  allowed_cidr_blocks = [ "0.0.0.0/0" ]
  tags = {
    Name = "maxwell-ec2-dev-icmp-sg"
    Environment = "dev"
  }
}

```

