## Function

perform as aws ec2 iam role collection will output instance profile name which can be attached to EC2 instance 

This module will give EC2 access to :

- aws ecr readonly

- aws s3 readonly

- aws cloudwatch to collect ec2 logs and send to aws cloudwatch loggroup


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

module "maxwell-ec2-iam" {
  source = "./modules/aws-iam-ec2"
  project_name = "gopay-service"
  bucket_names = [ 
    module.gopay-s3.bucket_name,
    module.maxwell-s3.bucket_name
   ]
}

```

If you use the EC2 to pull images from ECR for the first time you need to login ECR on that EC2 instance firstly

```shell
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 317429619308.dkr.ecr.us-east-1.amazonaws.com

# then pull the image
docker pull 317429619308.dkr.ecr.us-east-1.amazonaws.com/gopay-web-frontend:v1.0.0

```


