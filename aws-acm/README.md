## Function

perform as aws SSL certificate request, the aws will provide you a TLS certificate

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

module "gopay_web_acm" {
  source = "./modules/aws-acm"

  domain_name = "awsmpc.asia"

  zone_id     = module.gopay_dns.zone_id

  subject_alternative_names = ["*.awsmpc.asia"] # for api.awsmpc.asia using

  tags = {
    Name         = "awsmpc.asia-cert"
    Environment  = "prod"
  }
}

```

