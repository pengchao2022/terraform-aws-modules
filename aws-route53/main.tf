# create host zone
resource "aws_route53_zone" "this" {
  name = var.domain_name
  tags = var.tags
}

# create dns records
resource "aws_route53_record" "records" {
  for_each = { for rec in var.records : "${rec.name}-${rec.type}" => rec }

  zone_id = aws_route53_zone.this.zone_id
  name    = each.value.name
  type    = each.value.type

  set_identifier = each.value.set_identifier

  # if use alias will not set ttl and reocrds
  ttl     = each.value.alias == null ? each.value.ttl : null
  records = each.value.alias == null ? each.value.records : null

  dynamic "alias" {
    for_each = each.value.alias != null ? [each.value.alias] : []
    content {
      name                   = alias.value.name
      zone_id                = alias.value.zone_id
      evaluate_target_health = alias.value.evaluate_target_health
    }
  }

  # when routing policy is weighted
  dynamic "weighted_routing_policy" {
    for_each = each.value.routing_policy == "weighted" ? [1] : []
    content {
      weight = each.value.weight
    }
  }
}
