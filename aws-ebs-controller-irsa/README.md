## Function

perform as aws ebs csi driver installation

terraform will create the IAM role with IAM policy from aws side

helm will create the service account from kubernetes side

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

terraform will create the IAM role with policy

```shell

module "ebs_csi_controller_irsa_dev" {
  source = "./modules/aws-ebs-controller-irsa"

  role_name = "ebs-csi-controller-role"

  cluster_name = module.gopay_dev_eks.cluster_name

  cluster_oidc_issuer_url = module.gopay_dev_eks.cluster_oidc_issuer_url
  
}

```

helm create the service account form kubernetes side and install the driver

```shell

# added the ebs csi driver repo
helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver

# update the the repo 
helm repo update

helm upgrade --install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver \
  --namespace kube-system \
  --set controller.serviceAccount.create=true \
  --set controller.serviceAccount.name=ebs-csi-controller-sa \
  --set "controller.serviceAccount.annotations.eks\.amazonaws\.com/role-arn=arn:aws:iam::317429619308:role/ebs-csi-controller-role"

```

If you want to put the ebs-csi-controller pod on system-infra node-group run like this:

```shell

helm upgrade --install aws-ebs-csi-driver aws-ebs-csi-driver/aws-ebs-csi-driver \
  --namespace kube-system \
  --set controller.serviceAccount.create=true \
  --set controller.serviceAccount.name=ebs-csi-controller-sa \
  --set "controller.serviceAccount.annotations.eks\.amazonaws\.com/role-arn=arn:aws:iam::317429619308:role/ebs-csi-controller-role-maxwell" \
  --set controller.nodeSelector."node-group"="system-infra" \
  --set 'controller.tolerations[0].key=node-role' \
  --set 'controller.tolerations[0].operator=Equal' \
  --set 'controller.tolerations[0].value=infrastructure' \
  --set 'controller.tolerations[0].effect=NoSchedule'

```

To check all the pods running on which node-group run the following command:

```shell


  kubectl get pods -n kube-system -o custom-columns=NAME:.metadata.name,NODE:.spec.nodeName --no-headers | \
while read pod node; do \
  group=$(kubectl get node $node -o jsonpath='{.metadata.labels.eks\.amazonaws\.com/nodegroup}'); \
  echo "$pod Running on $group"; \
done

```

Please be noticed when you install ebs csi on EKS, then two kind of pods will be installed

- ebs-csi-controller

- ebs-csi-node   - This ebs-csi-node will be installed on every node 






