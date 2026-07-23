# eks cluster iam role
resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_vpc_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}


# EKS Cluster Security Group
resource "aws_security_group" "cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.cluster_name}-cluster-sg" })
}

resource "aws_security_group_rule" "cluster_ingress_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = var.cluster_endpoint_public_access_cidrs
  security_group_id = aws_security_group.cluster.id
  description       = "Allow API access from specified CIDRs"
}

resource "aws_security_group_rule" "cluster_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.cluster.id
}

# create EKS Cluster
data "aws_caller_identity" "current" {}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = var.cluster_version

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids              = concat(var.private_subnet_ids, var.public_subnet_ids)
    security_group_ids      = [aws_security_group.cluster.id]
    endpoint_private_access = var.cluster_endpoint_private_access
    endpoint_public_access  = var.cluster_endpoint_public_access
    public_access_cidrs     = var.cluster_endpoint_public_access_cidrs
  }

  encryption_config {
    provider { key_arn = var.kms_key_arn != null ? var.kms_key_arn : aws_kms_key.eks[0].arn }
    resources = ["secrets"]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_policy,
    aws_iam_role_policy_attachment.cluster_vpc_policy,
  ]
  tags = var.tags
  lifecycle { create_before_destroy = true }
}

data "tls_certificate" "this" {
  url = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# declare oidc provider
resource "aws_iam_openid_connect_provider" "this" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.this.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.this.identity[0].oidc[0].issuer
}

# KMS Key with EKS Permissions 
resource "aws_kms_key" "eks" {
  count = var.kms_key_arn == null ? 1 : 0
  description             = "KMS key for EKS cluster ${var.cluster_name}"
  deletion_window_in_days = 7
  enable_key_rotation     = true
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowEKS"
        Effect = "Allow"
        Principal = { Service = "eks.amazonaws.com" }
        Action = ["kms:Encrypt", "kms:Decrypt", "kms:GenerateDataKey*", "kms:DescribeKey", "kms:CreateGrant"]
        Resource = "*"
      },
      {
        Sid    = "AllowAdmin"
        Effect = "Allow"
        Principal = { AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root" }
        Action = "kms:*"
        Resource = "*"
      }
    ]
  })
  tags = var.tags
}

resource "aws_kms_alias" "eks" {
  count         = var.kms_key_arn == null ? 1 : 0
  name          = "alias/eks-${var.cluster_name}"
  target_key_id = aws_kms_key.eks[0].key_id
}

# eks managed node group
resource "aws_iam_role" "nodes" {
  name = "${var.cluster_name}-nodes-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "nodes_worker_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_container_registry_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

resource "aws_iam_role_policy_attachment" "nodes_ssm_policy" {
  count      = var.enable_ssm_access ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.nodes.name
}


resource "aws_iam_policy" "node_kms_decrypt" {
  name = "${var.cluster_name}-node-kms-decrypt"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["kms:Decrypt"]
      Effect   = "Allow"
      Resource = [var.kms_key_arn != null ? var.kms_key_arn : aws_kms_key.eks[0].arn]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "nodes_kms_policy" {
  policy_arn = aws_iam_policy.node_kms_decrypt.arn
  role       = aws_iam_role.nodes.name
}

# Node Group Security Group
resource "aws_security_group" "nodes" {
  name        = "${var.cluster_name}-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id
  tags        = merge(var.tags, { Name = "${var.cluster_name}-nodes-sg" })
}

resource "aws_security_group_rule" "nodes_self_ingress" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nodes.id
  security_group_id        = aws_security_group.nodes.id
  depends_on               = [aws_security_group.nodes, aws_security_group.cluster]
}

resource "aws_security_group_rule" "nodes_cluster_ingress" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.cluster.id
  security_group_id        = aws_security_group.nodes.id
  depends_on               = [aws_security_group.nodes, aws_security_group.cluster]
}

resource "aws_security_group_rule" "cluster_nodes_ingress" {
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.nodes.id
  security_group_id        = aws_security_group.cluster.id
  depends_on               = [aws_security_group.nodes, aws_security_group.cluster]
}

resource "aws_security_group_rule" "nodes_vpc_ingress" {
  type              = "ingress"
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = [var.vpc_cidr] 
  security_group_id = aws_security_group.nodes.id
  description       = "Allow inbound traffic from entire VPC to fix endpoint/dns rejects"
  depends_on        = [aws_security_group.nodes, aws_security_group.cluster]
}

resource "aws_security_group_rule" "nodes_egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.nodes.id
  depends_on        = [aws_security_group.nodes, aws_security_group.cluster]
}

resource "aws_launch_template" "nodes" {
  for_each = var.node_groups

  name_prefix   = "${var.cluster_name}-${each.key}-"
  image_id      = var.ami_id
  instance_type = lookup(each.value, "instance_types", var.instance_types)[0]
  block_device_mappings {
    device_name = "/dev/sda1" 
    ebs {
      volume_size = lookup(each.value, "root_volume_size", var.root_volume_size)
      volume_type = "gp3"
      delete_on_termination = true
    }
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    set -o xtrace
    /etc/eks/bootstrap.sh '${var.cluster_name}'
    EOF
  )

  vpc_security_group_ids = [aws_security_group.nodes.id]

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "${var.cluster_name}-${each.key}-node" })
  }
}

resource "aws_eks_node_group" "this" {
  for_each        = var.node_groups 
  
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = each.key
  node_role_arn   = aws_iam_role.nodes.arn
  
  subnet_ids      = lookup(each.value, "subnet_ids", var.private_subnet_ids)
  
  capacity_type   = lookup(each.value, "capacity_type", var.capacity_type)
  labels          = merge(var.node_labels, lookup(each.value, "labels", {}))

  launch_template {
    id      = aws_launch_template.nodes[each.key].id
    version = "$Latest"
  }

  scaling_config {
    desired_size = each.value.desired_size
    max_size     = each.value.max_size
    min_size     = each.value.min_size
  }

  lifecycle { create_before_destroy = true }
  depends_on = [
    aws_iam_role_policy_attachment.nodes_worker_policy,
    aws_iam_role_policy_attachment.nodes_cni_policy,
  ]
}


# export kubeconfig info for remote connect 
locals {
  kubeconfig = {
    apiVersion = "v1"
    clusters   = [{ cluster = { server = aws_eks_cluster.this.endpoint, certificate-authority-data = aws_eks_cluster.this.certificate_authority[0].data }, name = aws_eks_cluster.this.name }]
    contexts   = [{ context = { cluster = aws_eks_cluster.this.name, user = aws_eks_cluster.this.name }, name = aws_eks_cluster.this.name }]
    users      = [{ name = aws_eks_cluster.this.name, user = { exec = { apiVersion = "client.authentication.k8s.io/v1beta1", command = "aws", args = ["eks", "get-token", "--cluster-name", aws_eks_cluster.this.name, "--region", var.aws_region] } } }]
  }
}