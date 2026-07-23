## Function

perform as aws private ECR create, Here we will create an AWS private ECR

- the EKS nodes should have IAM role to ready ECR

- If you want special pod to pull from ECR then the pod should have IRSA 

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

module "gopay_private_ecr" {

  source = "./modules/aws-ecr-private"

  repository_name = "gopay-web-frontend"

  image_tag_mutability = "MUTABLE"

  scan_on_push = true

  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description = "Keep last 30 tagged images"
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  tags = {
    Environment = "dev"
    Terraform   = "true" 
  }
}


```

Here also give one example to build image and push to ECR

```shell
# login to aws ECR
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 317429619308.dkr.ecr.us-east-1.amazonaws.com

# pull to image locally if you docker build failed directly
docker pull --platform linux/amd64 python:3.11-slim

# docker build and push to ECR
# gopay-web-frontend this is the repo name when you use terraform created in ECR
docker buildx build --platform linux/amd64 \
  -t 317429619308.dkr.ecr.us-east-1.amazonaws.com/gopay-web-frontend:v1.0.0 \
  --push .

```



