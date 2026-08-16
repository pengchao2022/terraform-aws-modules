output "cloudtrail_policy_id" {
  value = aws_organizations_policy.protect_cloudtrail.id
}

output "region_restriction_policy_id" {
  value = aws_organizations_policy.region_restriction.id
}

output "prevent_destructive_policy_id" {
  value = aws_organizations_policy.prevent_destructive_actions.id
}