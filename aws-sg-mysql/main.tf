resource "aws_security_group" "this" {
  name        = var.name
  description = var.description  
  vpc_id      = var.vpc_id

  # mysql inbound rule
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = var.allowed_security_group_ids
    cidr_blocks     = var.allowed_cidr_blocks
    description     = "Allow MYSQL access from App servers"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  tags = var.tags
  
}