## Function

perform as aws vpc create, This module supports two kinds of VPC 

  - VPC for General using

  - VPC for AWS EKS cluster

     
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

- VPC for EKS cluster

- For a EKS cluster using, you need to tag the private subnets and public subnets so that ALB can 

  auto discover which network is public or private when create the alb

```shell

module "gopay_eks_dev_vpc" {
  source = "./modules/aws-vpc"
  providers = {
    aws = aws.east
  }
  environment = "dev"
  vpc_cidr = "172.16.0.0/16"
  project_name = "gopay-service-eks"
  private_subnets_cidr = [ "172.16.1.0/24", "172.16.2.0/24", "172.16.3.0/24" ]
  public_subnets_cidr  = [ "172.16.4.0/24", "172.16.5.0/24", "172.16.6.0/24" ]
  nat_gateway_count    = 3
  # EKS subnets need tags
  public_subnet_tags = {
    "kubernetes.io/cluster/gopay-eks-dev" = "shared" # here needs your EKS cluster name which will be created 
    "kubernetes.io/role/elb"                  = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/gopay-eks-dev" = "shared" # here needs your EKS cluster name which will be created
    "kubernetes.io/role/internal-elb"         = "1"
  }

}

```

- VPC for general using 

- In this case, you do not need tag the subnets

```shell

module "maxwell_dev_vpc" {
  source = "./modules/aws-vpc"
  providers = {
    aws = aws.east
  }
  environment = "dev"
  vpc_cidr = "172.20.0.0/16"
  project_name = "general-project"
  private_subnets_cidr = [ "172.20.1.0/24", "172.20.2.0/24", "172.20.3.0/24" ]
  public_subnets_cidr  = [ "172.20.4.0/24", "172.20.5.0/24", "172.20.6.0/24" ]
  nat_gateway_count    = 3

}

```


