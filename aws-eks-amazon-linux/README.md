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

## Real Prod environment

- In a real prod environment I will create several node groups like this

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
    # 基础设施/系统节点组 (Infra Group)
    # 作用：跑 ALB Controller, CoreDNS, Metrics Server, Monitoring 等
    # 策略：必须用 ON_DEMAND 保证绝对稳定，加 NO_SCHEDULE 污点保护
    "system-infra-v1" = {
      desired_size   = 2
      min_size       = 2
      max_size       = 4
      instance_types = ["t3.medium", "t3a.medium"] # 2 vCPU / 4GB 内存，确保足够 ENI 与内存空间
      capacity_type  = "ON_DEMAND"
      ami_type       = "AL2023_x86_64_STANDARD"
      
      labels = { 
        "node-group" = "system-infra" 
      }
      
      taints = [
        {
          key    = "node-role"
          value  = "infrastructure"
          effect = "NO_SCHEDULE" # 阻挡普通业务 Pod，系统组件需配 toleration 才能进来
        }
      ]
    },

    # x86 核心计算节点组 (Compute x86 Group)
    # 作用：运行不兼容 ARM 的传统 x86 无状态微服务
    # 策略：混合实例类型降低 Spot 回收风险
    "compute-x86-v1" = {
      desired_size   = 2
      min_size       = 2
      max_size       = 10
      instance_types = ["t3.small", "t3a.small"] 
      capacity_type  = "SPOT" # 生产环境可通过扩容多 AZ + 多规格降低 Spot 风险
      ami_type       = "AL2023_x86_64_STANDARD"
      
      labels = { 
        "node-group" = "compute-x86" 
      }
      
      taints = [] # 无污点，普通业务 Pod 默认落盘至此
    },

    # ARM64 高性价比计算节点组 (Compute ARM Group)
    # 作用：运行支持多架构/ARM 的微服务，省钱 20%+ 且性能更强
    # 策略：不设污点，通过 Pod 的 nodeSelector 自由选择
    "compute-arm-v1" = {
      desired_size   = 2
      min_size       = 2
      max_size       = 10
      instance_types = ["t4g.small", "t4g.medium"] 
      capacity_type  = "SPOT"
      ami_type       = "AL2023_ARM_64_STANDARD" 
      
      labels = { 
        "node-group" = "compute-arm" 
      }   
      
      taints = [] # 允许部署了 ARM 镜像的业务 Pod 自由调度进来
    }
  }

  node_labels = {
    "environment" = "prod"
  }
  
  tags = {
    Environment = "prod"
    Project     = "maxwell-service"
    Terraform   = "true"
  }

  enable_ssm_access = true
}

```

- Fox example, If you need to install alb ingress controller on system infra , then run the following command

```shell
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --version 3.4.2 \
  --set clusterName=maxwell-eks-dev \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="arn:aws:iam::317429619308:role/aws-load-balancer-controller-role" \
  --set enableShield=false \
  --set region=us-east-1 \
  --set vpcId=vpc-0d46942f993e02668 \
  --set nodeSelector."node-group"=system-infra \
  --set tolerations[0].key="node-role" \
  --set tolerations[0].operator="Equal" \
  --set tolerations[0].value="infrastructure" \
  --set tolerations[0].effect="NoSchedule"

```




