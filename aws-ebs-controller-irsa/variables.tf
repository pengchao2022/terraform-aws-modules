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
  default     = "AmazonEBSCSIDriverControllerRole"
  description = "IAM Role Name for EBS CSI Controller"
}

variable "service_account_name" {
  type        = string
  default     = "ebs-csi-controller-sa"
  description = "Kubernetes Service Account Name for EBS CSI"
}

variable "namespace" {
  type        = string
  default     = "kube-system"
  description = "Kubernetes Namespace"
}