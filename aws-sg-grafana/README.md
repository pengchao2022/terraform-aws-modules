## Function

perform as aws grafana security group creation

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

module "grafana_dev_sg" {
  source = "./modules/aws-sg-grafana"
  name   = "grafana-dev-sg"
  vpc_id = module.maxwell_vpc_dev.vpc_id

  # allow special network cidrs access grafana
  allowed_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  
  # allow security group ids access grafana
  allowed_security_group_ids = [ 
    module.web_server_dev_http_8080_sg.security_group_http_8080_id,
    module.web_server_dev_http_sg.security_group_http_id
  ]
  tags = {
    Name = "grafana-dev-sg"
    Environment = "dev"
  }
}

```

