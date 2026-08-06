## Function

perform as aws eks with amazon linux node create

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

this module will create eks with amazon linux instance and create eks-self-managed-node-group


```shell

module "maxwell_dev_eks" {
  source = "./modules/aws-eks-amazon-linux"

  aws_region          = "us-east-1"
  cluster_name        = "maxwell-eks-dev"
  cluster_version     = "1.36"

  vpc_id              = module.maxwell_dev_vpc.vpc_id
  private_subnet_ids  = module.maxwell_dev_vpc.private_subnet_ids
  public_subnet_ids   = module.maxwell_dev_vpc.public_subnet_ids

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  vpc_cidr = "172.20.0.0/16"

  root_volume_size = 20

  node_groups = {
    general-nodes-v3 = {
    desired_size   = 2
    max_size       = 2
    min_size       = 1
    instance_types = ["t3.micro"] 
    ami_type         = "AL2023_x86_64_STANDARD"
    capacity_type  = "ON_DEMAND"
    labels = { 
      "node-group" = "general-nodes-amd-v2" 
    }
    },
    "compute-nodes-arm-v1" = {
      desired_size   = 2
      max_size       = 2
      min_size       = 1
      instance_types = ["t4g.small"] 
      capacity_type  = "SPOT"
      ami_type       = "AL2023_ARM_64_STANDARD" 
      labels = { 
        "node-group" = "compute-nodes-arm-v1" 
      }          
    },
    "compute-nodes-v3" = {
      desired_size = 2
      max_size     = 2
      min_size     = 1
      instance_types = ["t3.small"] 
      ami_type         = "AL2023_x86_64_STANDARD"
      capacity_type  = "SPOT"
      labels = { 
        "node-group" = "compute-nodes-amd-v2" 
      }          
    }
  }
  node_labels = {
    "environment" = "dev"
  }
  
  tags = {
    Environment = "dev"
    Project     = "maxwell-service"
    Terraform   = "true"
  }

  enable_ssm_access = true
  
}

```
Here I use two different ami_type 

- "AL2023_x86_64_STANDARD"  for linux amd 

- "AL2023_ARM_64_STANDARD"  for linux arm 

amd or x86_64 is CISC 复杂指令集 CPU 代表作 Intel, AMD 系列

arm is RISC 精简指令集 CPU 代表作 Apple M 系列 




