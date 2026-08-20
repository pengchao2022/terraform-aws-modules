# define the general labels
locals {
  name_prefix = "${var.project_name}-${var.environment}"
  
  common_tags = merge(
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

# create ssh key pair
resource "aws_key_pair" "deployer" {
  key_name   = "${local.name_prefix}-key"
  public_key = var.public_key_content
  
  tags = local.common_tags
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
  iam_instance_profile        = var.iam_instance_profile
  user_data                   = var.user_data

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }
  
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.value}-server"
  })
}


# create EBS volume if needed
resource "aws_ebs_volume" "data_volume" {
  for_each          = var.enable_ebs_volume ? var.instance_suffix : []
  availability_zone = aws_instance.web_server[each.value].availability_zone
  size              = var.ebs_volume_size
  type              = "gp3"
  encrypted         = true

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-${each.value}-data-vol"
  })
}

resource "aws_volume_attachment" "data_volume_attach" {
  for_each    = var.enable_ebs_volume ? var.instance_suffix : []
  device_name = var.ebs_device_name
  volume_id   = aws_ebs_volume.data_volume[each.value].id
  instance_id = aws_instance.web_server[each.value].id
}