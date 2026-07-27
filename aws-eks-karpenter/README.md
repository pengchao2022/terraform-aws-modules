## Function

Here I will install karpenter on EKS using modules and helm charts

Terraform side:  mainly focus on IAM on AWS 

- Create AWS infrastructure : 

                             - IAM role for karpenter 

                             - NodeInstanceRole, Controller Role, AWS SQS , EventBridge rules and permissions 

Helm side:     mainly focus on Pod on EKS

- Install karpenter Pod on EKS: 

                              - karpenter controller pod running on EKS

                              - Using the IAM role ARN , Cluster Endpoint which created by terraform 


## Usage

Use the terraform karpenter module from github:

```shell


module "karpenter" {
  source = "terraform-aws-modules/eks/aws//modules/karpenter"
  version = ">= 21.9.0"

  namespace = "karpenter"

  cluster_name = module.maxwell_dev_eks.cluster_name

  # Attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }

  enable_inline_policy = true

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

```

output the karpenter related role which Helm install will be needed

```shell

# this from eks module
output "eks_cluster_name" {
  value = module.maxwell_dev_eks.cluster_name  
}

# also from the eks module
output "eks_cluter_endpoint" {
  value = module.maxwell_dev_eks.cluster_endpoint
}

# this from the karpenter module
output "karpenter_iam_role_arn" {
  description = "Karpenter controller IAM role ARN"
  value       = module.karpenter.iam_role_arn
}

# also from the karpenter module
output "karpenter_queue_name" {
  description = "Karpenter interraption SQS queue name"
  value       = module.karpenter.queue_name
}

# form karpenter module
output "karpenter_node_role_name" {
  value = module.karpenter.node_iam_role_name
  
}

```
Now use the helm charts to install karpenter 

```shell

# Install karpenter
helm upgrade --install karpenter oci://public.ecr.aws/karpenter/karpenter \
  --namespace karpenter \
  --create-namespace \
  --version 1.9.0 \
  --set settings.clusterName=maxwell-eks-dev \
  --set settings.clusterEndpoint=https://369D6921CD231965CDBA8B2255BEE658.gr7.us-east-1.eks.amazonaws.com \
  --set settings.interruptionQueue=Karpenter-maxwell-eks-dev \
  --set-string serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=arn:aws:iam::317429619308:role/KarpenterController-892cb1722e8b277e19cda7ea64 \
  --wait

```
If you have errors may need to unintall karpenter then use the follow command:

```shell
# uninstall karpenter
helm uninstall karpenter -n karpenter

```
Check if karpenter pods is ready to use:

```shell
allen@192 terraform-aws-modules % kubectl get pods -n karpenter
NAME                         READY   STATUS    RESTARTS   AGE
karpenter-7bdb7c97b4-95r2d   1/1     Running   0          3h3m
karpenter-7bdb7c97b4-gzszc   1/1     Running   0          3h3m

```
Now you need to define the ec2nodeclass and nodepool

ec2nodeclass.yaml

```shell
apiVersion: karpenter.k8s.aws/v1
kind: EC2NodeClass
metadata:
  name: default
spec:
  amiFamily: AL2023
  amiSelectorTerms:
    - alias: al2023@latest
  subnetSelectorTerms:
    - tags:
        kubernetes.io/cluster/maxwell-eks-dev: "*"
  securityGroupSelectorTerms:
    - tags:
        aws:eks:cluster-name: maxwell-eks-dev
  role: "Karpenter-maxwell-eks-dev-62f20b67dad1f2b96ed9df5a34"

```
nodepool.yaml

```shell
apiVersion: karpenter.sh/v1
kind: NodePool
metadata:
  name: default
spec:
  template:
    spec:
      nodeClassRef:
        group: karpenter.k8s.aws
        kind: EC2NodeClass
        name: default
      requirements:
        - key: "karpenter.sh/capacity-type"
          operator: In
          values: ["spot", "on-demand"]
        - key: "node.kubernetes.io/instance-type"
          operator: In
          values: ["t3.small", "t3.micro"]
  limits:
    cpu: "1000"
  disruption:
    consolidationPolicy: WhenEmptyOrUnderutilized 
    consolidateAfter: 30s

```

then use the kubectl command to deploy

```shell

kubectl apply -f karpenter-node-ppl/

```
After created , we use pod to test karpenter works or not

write a test deployment

inflate.yaml

```shell

apiVersion: apps/v1
kind: Deployment
metadata:
  name: inflate
spec:
  replicas: 0
  selector:
    matchLabels:
      app: inflate
  template:
    metadata:
      labels:
        app: inflate
    spec:
      containers:
        - name: inflate
          image: public.ecr.aws/eks-distro/kubernetes/pause:3.7
          resources:
            requests:
              cpu: "1"

```

then kubectl apply to create the test pod

```shell

kubectl apply -f inflate.yaml

```

Now let's try to create more pods to trigger karpenter to create more ec2 nodes

```shell

kubectl scale deployment inflate --replicas=10

```










              

