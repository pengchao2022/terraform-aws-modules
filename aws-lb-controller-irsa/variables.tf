variable "cluster_name" {
  type        = string
  description = "EKS Cluster Name"
}

variable "cluster_oidc_issuer_url" {
  type        = string
  description = "EKS Cluster OIDC Issuer URL (without https://)"
}

variable "role_name" {
  type        = string
  default     = "AmazonEKSLoadBalancerControllerRole"
  description = "IAM Role Name for the controller"
}

variable "service_account_name" {
  type        = string
  default     = "aws-load-balancer-controller"
  description = "Kubernetes Service Account Name"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes Namespace"
}