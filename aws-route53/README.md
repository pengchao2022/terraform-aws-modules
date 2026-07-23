## Function

perform as aws DNS route 53 creation

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

module "gopay_dns" {
  source = "./modules/aws-route53"

  domain_name = "awsmpc.asia"

  tags = {
    Name = "awsmpc.asia"
    Environment = "prod"
  }

  records = [ 
    {
      name     = ""     # this is for the top domain while using an aws alb
      type     = "A"
      alias    = {
        name                        = module.gopay_ecs_alb.alb_dns_name 
        zone_id                     = module.gopay_ecs_alb.alb_zone_id # this is the alb zone id
        evaluate_target_health      = true
      }
    },
    # sub domain record
    {
      name     = "api"
      type     = "A"
      alias    = {
        name                        = module.gopay_ecs_alb.alb_dns_name 
        zone_id                     = module.gopay_ecs_alb.alb_zone_id # this is the alb zone id
        evaluate_target_health      = true
      }
    }
    # if you have an EIP then you can also set EIP record
    # {
    #   name     = ""
    #   type     = "A"
    #   ttl      = 300
    #   records  = ["8.9.10.11"]
    # }
   ]
}


```

