# define the general labels
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# create ssh key pari
resource "aws_key_pair" "deployer" {
  key_name = "${local.name_prefix}-key"
  public_key = var.public_key_content
}

# create ec2 instance
resource "aws_instance" "web_server" {
  for_each      = var.instance_suffix
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_map[each.value]
  key_name      = aws_key_pair.deployer.key_name
  

  vpc_security_group_ids = var.existing_security_group_ids

  associate_public_ip_address = contains(var.public_ip_instances, each.key)
  iam_instance_profile = var.iam_instance_profile
  user_data            = var.user_data

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.value}-server"
  })
}



