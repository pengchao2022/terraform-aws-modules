## Function

perform as aws nlb for rabbitmq cluster creation

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


module "rabbitmq_nlb" {
  source = "./modules/aws-nlb-rabbitmq"

  vpc_id = "vpc-06441138f85f43fc9"
  subnet_ids = [
    "subnet-0696d896261cb6a11",
    "subnet-075775e23ae89f4db",
    "subnet-0f53a23f5a620d9e4"
  ]


  rabbitmq_instance_ids = [
    "i-0151b2d31e23d7179",
    "i-0c08298e8aaf956a4",
    "i-05ff58e8bcc1216bc"
  ]

  is_internal = false 

  tags = {
    Environment = "production"
    Project     = "RabbitMQ-Cluster"
    ManagedBy   = "Terraform"
  }
}


```

