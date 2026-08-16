## Function

perform as aws Organization OU creation.

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

module "maxwell_prod_ou" {
  source = "./modules/aws-ous"

  parent_id = "r-9nci"
  ou_name   = "Production"
}

module "maxwell_dev_ou" {
  source = "./modules/aws-ous"

  parent_id = "r-9nci"
  ou_name   = "Development"
}

```

