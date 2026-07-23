output "kubeconfig" {
  value     = yamlencode(local.kubeconfig)
  sensitive = true 
}

output "cluster_endpoint" {
  description = "The endpoint for your EKS Kubernetes API"
  value       = aws_eks_cluster.this.endpoint
}

output "cluster_certificate_authority_data" {
  description = "The CA data for the EKS cluster"
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
}


output "cluster_security_group_id" {
  description = "The security group ID attached to the EKS cluster"
  value       = aws_security_group.cluster.id
}

output "node_security_group_id" {
  description = "The security group ID attached to the EKS nodes"
  value       = aws_security_group.nodes.id
}

output "node_group_status" {
  description = "The status of the EKS managed node group"
  value       = try(aws_eks_node_group.this[0].status, "N/A")
}

output "node_group_arn" {
  description = "The ARN of the EKS managed node group"
  value       = try(aws_eks_node_group.this[0].arn, "N/A")
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = aws_eks_cluster.this.name
}

output "cluster_oidc_issuer_url" {
  description = "The URL on the EKS cluster for the OpenID Connect identity provider"
  value       = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider"
  value       = aws_iam_openid_connect_provider.this.arn
}