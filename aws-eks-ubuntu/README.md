## Function

perform as aws eks with ubuntu node create

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

this module will create eks with ubuntu instance and create eks-self-managed-node-group


```shell

module "gopay_prod_eks" {
  source = "./modules/aws-eks-ubuntu" 

  cluster_name    = "gopay-production"
  cluster_version = "1.35"

  vpc_id             = module.gopay_eks_prod_vpc.vpc_id
  vpc_cidr           = "10.1.0.0/16"
  private_subnet_ids = module.gopay_eks_prod_vpc.private_subnet_ids
  public_subnet_ids  = module.gopay_eks_prod_vpc.public_subnet_ids

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]

  root_volume_size = 20
  ami_id = "ami-0f89c7be98052c189" # match the kubernetes version 1.35
 
  node_groups = {
    "general-nodes" = {
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
    "environment" = "prod"
  }
  
  tags = {
    Environment = "prod"
    Project     = "gopay-service"
    Terraform   = "true"
  }

  enable_ssm_access = true
}

```


