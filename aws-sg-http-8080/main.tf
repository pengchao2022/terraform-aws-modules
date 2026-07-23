resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  # inbound rule allow 8080
  ingress {
    from_port      = 8080
    to_port        = 8080
    protocol       = "tcp"
    cidr_blocks    = var.allowed_cidr_blocks
    description    = "Allow Http-8080 access"
  }

  egress {
    from_port      = 0
    to_port        = 0
    protocol       = "-1"
    cidr_blocks    = ["0.0.0.0/0"]
    description    = "Allow all outbound traffic"
  }

  tags = var.tags
}