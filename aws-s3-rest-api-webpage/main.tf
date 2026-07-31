resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true
  tags          = var.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket                  = aws_s3_bucket.this.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false 
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.this.arn}/*"
      },
    ]
  })

  depends_on = [ aws_s3_bucket_public_access_block.this ]
  
}

# upload local index.html and images with correct content_type
resource "aws_s3_object" "website_files" {
  for_each     = fileset("${path.module}/static", "**/*")
  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "${path.module}/static/${each.value}"
  etag         = filemd5("${path.module}/static/${each.value}")
  
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "png"  = "image/png",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml"
  }, regex("\\.([^.]+)$", each.value)[0], "application/octet-stream")
}