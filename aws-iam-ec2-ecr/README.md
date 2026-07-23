## Function

perform as given EC2 instance the ECR access, then will output the instance_profile_name which you can attache to your EC2 

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

module "ec2_ecr_role" {
  source = "./modules/aws-iam-ec2-ecr"

  role_name = "maxwell-ec2-ecr-role"

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

```
If you use the EC2 to pull images from ECR for the first time you need to login ECR on that EC2 instance firstly

```shell
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 317429619308.dkr.ecr.us-east-1.amazonaws.com

# then pull the image
docker pull 317429619308.dkr.ecr.us-east-1.amazonaws.com/gopay-web-frontend:v1.0.0

```




