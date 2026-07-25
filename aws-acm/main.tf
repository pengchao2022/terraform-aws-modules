# apply for certificate
resource "aws_acm_certificate" "this" {
  domain_name                 = var.domain_name
  subject_alternative_names   = var.subject_alternative_names
  validation_method           = "DNS"

  tags = var.tags                      

  lifecycle {
    create_before_destroy = true
  }
}

# automatically assign dns record
resource "aws_route53_record" "validation" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = var.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [ each.value.record ]
  ttl     = 60

  allow_overwrite = true
  
}