locals {
  resource_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# create vpc
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${local.resource_prefix}-vpc"}
}

resource "aws_internet_gateway" "igw" {
  vpc_id               = aws_vpc.main.id
  tags                 = { Name = "${local.resource_prefix}-igw"} 
}

resource "aws_subnet" "public" {
  count                = length(var.public_subnets_cidr)
  vpc_id               = aws_vpc.main.id
  cidr_block           = var.public_subnets_cidr[count.index]
  availability_zone    = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]
  map_public_ip_on_launch = true
  
  tags = merge(
    { Name = "${local.resource_prefix}-public-${count.index + 1}" },
    local.common_tags,      
    var.public_subnet_tags  
  )
}


resource "aws_subnet" "private" {
  count                = length(var.private_subnets_cidr)
  vpc_id               = aws_vpc.main.id
  cidr_block           = var.private_subnets_cidr[count.index]
  availability_zone    = data.aws_availability_zones.available.names[count.index % length(data.aws_availability_zones.available.names)]

  tags = merge(
    { Name = "${local.resource_prefix}-private-${count.index + 1}"},
    local.common_tags,      
    var.private_subnet_tags 
  )
}

# create EIP for NAT , one NAT match one EIP
resource "aws_eip" "nat" {
  count  = var.nat_gateway_count
  domain = "vpc"
  tags = {
    Name        = "${local.resource_prefix}-nat-eip-${count.index + 1}"
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_nat_gateway" "nat" {
  count         = var.nat_gateway_count
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id
  depends_on    = [ aws_internet_gateway.igw ]
  tags          = {
    Name        = "${local.resource_prefix}-nat-${count.index + 1}"
    Environment = var.environment
    Project     = var.project_name
  }
}

# create public router
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${local.resource_prefix}-public-rt" }
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table" "private" {
  count  = var.nat_gateway_count
  vpc_id = aws_vpc.main.id
  tags   = { Name = "${local.resource_prefix}-private-rt-${count.index + 1}" }
}

resource "aws_route" "private_nat" {
  count                  = var.nat_gateway_count
  route_table_id         = aws_route_table.private[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id
}


resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}

# create sg for vpc endpoint
resource "aws_security_group" "endpoint_sg" {
  name        = "${var.project_name}-endpoint-sg"
  description = "Security group for VPC Endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTPS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ var.vpc_cidr ] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = { Name = "${var.project_name}-endpoint-sg"}
}


# CloudWatch VPC Flow Logs
# create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "vpc_flow_log" {
  name              = "/aws/vpc-flow-logs/${local.resource_prefix}"
  retention_in_days = 7 # the days to keep logs

  tags = local.common_tags
}

# create iam role to allow vpc write logs
resource "aws_iam_role" "vpc_flow_log_role" {
  name = "${local.resource_prefix}-vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name = "${local.resource_prefix}-vpc-flow-log-policy"
  role = aws_iam_role.vpc_flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# attach vpc flow log to this VPC
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.vpc_flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log.arn
  traffic_type    = "ALL" # record ACCEPT and REJECT network traffic
  vpc_id          = aws_vpc.main.id

  tags = merge(
    { Name = "${local.resource_prefix}-flow-log" },
    local.common_tags
  )
}