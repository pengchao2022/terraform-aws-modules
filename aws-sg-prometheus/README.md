## Function

perform as aws prometheus security group creation

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

module "web_server_dev_prometheus_server_sg" {
  source = "./modules/aws-sg-prometheus"
  name   = "prometheus-server-sg"
  vpc_id = module.maxwell_vpc_dev.vpc_id

  # enable necessary service port
  enable_prometheus_ui = true
  enable_node_exporter = true
  enable_pushgateway   = false     # prometheus server do not need to collect himself

  allowed_security_group_ids = [ 
    module.web_server_dev_http_8080_sg.security_group_http_8080_id,
    module.web_server_dev_http_sg.security_group_http_id
  ]

  allowed_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  tags = {
    Name = "prometheus-server-dev-sg"
    Environment = "dev"
  }
}

```

