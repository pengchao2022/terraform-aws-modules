data "aws_region" "current" {}

locals {
  has_archive = var.archive_s3_bucket_arn != null && var.archive_s3_bucket_arn != "" ? 1 : 0
  safe_name = replace(trimprefix(var.log_group_name, "/"), "/", "-")
}

# create cloudwatch log group
resource "aws_cloudwatch_log_group" "this" {
  name              = var.log_group_name
  retention_in_days = var.retention_in_days
  
  tags = var.tags
}

# create role for flow log
resource "aws_iam_role" "flow_log_role" {
  name = "${local.safe_name}-flow-log-role"
  
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
  
  tags = var.tags
}

resource "aws_iam_role_policy" "flow_log_policy" {
  role = aws_iam_role.flow_log_role.id
  
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
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

# VPC Flow Logs
resource "aws_flow_log" "this" {
  vpc_id          = var.vpc_id
  log_destination = aws_cloudwatch_log_group.this.arn
  traffic_type    = var.traffic_type
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  
  tags = var.tags
}

# Kinesis Firehose only available when you use s3 archive
resource "aws_kinesis_firehose_delivery_stream" "archive" {
  count = local.has_archive
  
  name = "${local.safe_name}-archive"
  destination = "extended_s3"

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role[0].arn
    bucket_arn = var.archive_s3_bucket_arn
    
    prefix              = "logs/${var.log_group_name}/"
    error_output_prefix = "logs/error/"
    buffering_size      = 5
    buffering_interval  = 300
    compression_format  = "GZIP"
  }
  
  tags = var.tags
}

# cloudwatch subscribe log filter
resource "aws_cloudwatch_log_subscription_filter" "this" {
  count = local.has_archive
  
  name            = "${local.safe_name}-archive-filter"
  log_group_name  = aws_cloudwatch_log_group.this.name
  filter_pattern  = ""
  destination_arn = aws_kinesis_firehose_delivery_stream.archive[0].arn
  role_arn        = aws_iam_role.cw_to_firehose_role[0].arn
  
  depends_on = [
    aws_kinesis_firehose_delivery_stream.archive,
    aws_iam_role.cw_to_firehose_role
  ]
}

# create iam role for firehose
resource "aws_iam_role" "firehose_role" {
  count = local.has_archive
  
  name = "${local.safe_name}-firehose-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
  
  tags = var.tags
}

resource "aws_iam_role_policy" "firehose_s3" {
  count = local.has_archive
  
  role = aws_iam_role.firehose_role[0].id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:GetObject"
        ]
        Effect = "Allow"
        Resource = [
          "${var.archive_s3_bucket_arn}/*"
        ]
      },
      {
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Effect = "Allow"
        Resource = [
          var.archive_s3_bucket_arn
        ]
      }
    ]
  })
}

# attach cloudwatch to firehose
resource "aws_iam_role" "cw_to_firehose_role" {
  count = local.has_archive
  
  name = "${local.safe_name}-cw-to-fh-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "logs.${data.aws_region.current.region}.amazonaws.com"
        }
      }
    ]
  })
  
  tags = var.tags
}

resource "aws_iam_role_policy" "cw_to_firehose_policy" {
  count = local.has_archive
  
  role = aws_iam_role.cw_to_firehose_role[0].id
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ]
        Effect = "Allow"
        Resource = aws_kinesis_firehose_delivery_stream.archive[0].arn
      }
    ]
  })
}
