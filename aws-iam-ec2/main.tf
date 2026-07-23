# define trust policy assume role
resource "aws_iam_role" "ec2_s3_role" {
  name = "${var.project_name}-ec2-s3-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {Service = "ec2.amazonaws.com"}
    }]
  }) 
}

# s3 readonly access
resource "aws_iam_role_policy" "s3_access" {
  name    = "s3-access-policy"
  role    = aws_iam_role.ec2_s3_role.id
  policy  = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = ["s3:GetObject", "s3:ListBucket", "s3:PutObject"]
      Effect = "Allow"
      Resource = flatten([
        for name in var.bucket_names : [
          "arn:aws:s3:::${name}",
          "arn:aws:s3:::${name}/*"
        ]
      ])
    }]
  })
}

# cloudwatch agent to get collect logs 
resource "aws_iam_role_policy_attachment" "cloudwatch_agent_attch" {
  role        = aws_iam_role.ec2_s3_role.name
  policy_arn  = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# allow ec2 to read only aws ecr
resource "aws_iam_role_policy_attachment" "ecr_readonly_attach" {
  role        = aws_iam_role.ec2_s3_role.name
  policy_arn  = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_role_policy" "ssm_read_policy" {
  name = "allow-read-cw-ssm-config"
  role = aws_iam_role.ec2_s3_role.id 

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action   = ["ssm:GetParameter"]
      Effect   = "Allow"
      Resource = "arn:aws:ssm:region:account-id:parameter/cw-agent/*" # 匹配你的路径
    }]
  })
}

# create Instance Profile for ec2
resource "aws_iam_instance_profile" "this" {
  name      = "${var.project_name}-instance-profile"
  role      = aws_iam_role.ec2_s3_role.name
}