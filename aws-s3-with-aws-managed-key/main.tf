resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags = var.tags
}

# 确保私有访问（保持原样）
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 添加 AWS 托管的 KMS 密钥加密配置
resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      # 指定使用 kms 加密
      sse_algorithm = "aws:kms"
      # 指定使用 AWS 托管的密钥 alias/aws/s3
      kms_master_key_id = "alias/aws/s3"
    }
    bucket_key_enabled = true
  }

  
}

resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  
  versioning_configuration {
    status = var.enable_versioning ? "Enabled" : "Suspended"
  }
}