output "zone_id" {
  description = "The ID of AWS ROute53 host"
  value       = aws_route53_zone.this.zone_id
}

output "name_server" {
  description = "The NS records assigned by Route53"
  value       = aws_route53_zone.this.name_servers
}

output "record_names" {
  description = "Print all the dns records"
  value       = [for rec in aws_route53_record.records : rec.name]
}