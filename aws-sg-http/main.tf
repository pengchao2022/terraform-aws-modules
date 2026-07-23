resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  # http 80 ingress rule
  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
    description = "Allow HTTP access"
  }

  # allow all egress traffic
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
    description = "Allow all egress traffic"
  }
  tags = var.tags
}