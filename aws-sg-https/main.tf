resource "aws_security_group" "this" {
  name         = var.name
  description  = var.description
  vpc_id       = var.vpc_id

  # allow https 443 ingress inbound rule
  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
    description = "Allow Https access"
  }

  # allow all outbound traffic rule
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = var.tags
}

