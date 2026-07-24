# get the OIDC provider tls cert
data "tls_certificate" "this" {
  url      = var.url
}

# create IAM OIDC Provider
resource "aws_iam_openid_connect_provider" "this" {
  url      = var.url


  thumbprint_list = [ data.tls_certificate.this.certificates[0].sha1_fingerprint ]

  client_id_list = length(var.client_id_list) > 0 ? var.client_id_list : [var.url]

  tags = var.tags
  
}