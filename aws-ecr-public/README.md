## Function

perform as aws public ECR 

please be noticed public ECR does not have scan on push option 

but public ECR has alias which private ECR does not have 

when you need to push to public ECR you need this alias

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
Use aws cli to check the public ECR alias

```shell

allen@192 ~ % aws ecr-public describe-registries --region us-east-1 --output json
{
    "registries": [
        {
            "registryId": "317429619308",
            "registryArn": "arn:aws:ecr-public::317429619308:registry/317429619308",
            "registryUri": "public.ecr.aws/l4w8c3b8",
            "verified": false,
            "aliases": [
                {
                    "name": "l4w8c3b8", # this is the alias 
                    "status": "ACTIVE",
                    "primaryRegistryAlias": true,
                    "defaultRegistryAlias": true
                }
            ]
        }
    ]
}

```
login to public ECR
```shell

aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

```

docker build and push image to public ECR using alias

```shell

docker buildx build --platform linux/amd64 \
  -t public.ecr.aws/l4w8c3b8/gopay-public-api:v2.0.0 \
  --push .

```







