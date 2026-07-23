## Function

perform as aws alb controller installation 

terraform will create the role with iam policy from aws side

helm will create the service account and install controller from kubernetes side

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

use this module to create IRSA from terraform side

```shell

module "lb_controller_irsa_dev" {
  source = "./modules/aws-lb-controller-irsa"

  role_name               = "aws-load-balancer-controller-role"

  cluster_name            = module.gopay_dev_eks.cluster_name

  cluster_oidc_issuer_url = module.gopay_dev_eks.cluster_oidc_issuer_url
    
}

```

helm create the service account from kubernetes side and install the controller

```shell

# add the eks helm charts repo
helm repo add eks https://aws.github.io/eks-charts

# helm update
helm repo update

helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --version 3.4.2 \
  --set clusterName=gopay-eks-dev \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"="arn:aws:iam::317429619308:role/aws-load-balancer-controller-role" \
  --set enableShield=false \
  --set region=us-east-1 \
  --set vpcId=vpc-046ee3e3ebd8192f6

  ```

