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

module "gopay_dev_eks" {
  source = "./modules/aws-eks-amazon-linux"

  aws_region          = "us-east-1"
  cluster_name        = "gopay-eks-dev"
  cluster_version     = "1.35"

  vpc_id              = module.gopay_eks_dev_vpc.vpc_id
  vpc_cidr            = "172.16.0.0/16"
  private_subnet_ids  = module.gopay_eks_dev_vpc.private_subnet_ids
  public_subnet_ids   = module.gopay_eks_dev_vpc.public_subnet_ids

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  root_volume_size = 20
  ami_type         = "AL2023_x86_64_STANDARD"

  node_groups = {
    general-nodes = {
      desired_size = 4
      max_size     = 4
      min_size     = 4
      instance_types = ["t3.small"]
      capacity_type  = "ON_DEMAND"
      labels = { 
        "node-group" = "general-nodes" 
      } 
    },
    "compute-nodes" = {
      desired_size = 4
      max_size     = 4
      min_size     = 4
      instance_types = ["t3.small"] 
      capacity_type  = "SPOT"
      labels = { 
        "node-group" = "compute-nodes" 
      }          
    }
  }
  node_labels = {
    "environment" = "dev"
  }
  
  tags = {
    Environment = "dev"
    Project     = "gopay-service"
    Terraform   = "true"
  }

  enable_ssm_access = true
  
}

```


