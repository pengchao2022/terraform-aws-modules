## Function

perform as aws public ECR

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

module "gopay_public_ecr" {
  source = "./modules/aws-ecr-public"

  repository_name = "gopay-public-api"

  catalog_data = {
    description       = "Public docker image for Gopay services"
    operating_systems = [ "Linux" ]
    architectures     = [ "x86_64", "ARM 64" ]
  }
  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

```

