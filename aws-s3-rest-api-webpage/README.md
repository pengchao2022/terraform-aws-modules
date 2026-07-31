## Function

perform as aws s3 website with rest api HTTPS support

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

module "maxwell_s3_rest_api_website" {
  source = "./modules/aws-s3-rest-api-webpage"

  bucket_name = "prometheus-mercedes-0520-demo"

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
  
}

```

the website looks like:

![mercedes](./demo-site.png)




