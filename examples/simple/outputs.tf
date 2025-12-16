output "summary" {
  description = "Summary of created resources"
  value = {
    custom_roles   = keys(module.hiiretail_iam.custom_roles)
    business_units = keys(module.hiiretail_iam.business_units)
    groups         = keys(module.hiiretail_iam.groups)
    role_bindings  = length(module.hiiretail_iam.role_bindings)
  }
}

output "groups_detail" {
  description = "Detailed information about created groups"
  value       = module.hiiretail_iam.groups
}
