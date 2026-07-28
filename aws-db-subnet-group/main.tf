resource "aws_db_subnet_group" "this" {

  name        = var.name
  description = var.description
  subnet_ids  = var.subnet_ids

  tags = var.tags
  
}