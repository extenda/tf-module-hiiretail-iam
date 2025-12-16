output "custom_roles" {
  description = "Created custom roles"
  value       = module.hiiretail_iam.custom_roles
}

output "business_units" {
  description = "Created business units"
  value       = module.hiiretail_iam.business_units
}

output "groups" {
  description = "Manually created groups"
  value       = module.hiiretail_iam.groups
}

output "role_bindings" {
  description = "Manually created role bindings"
  value       = module.hiiretail_iam.role_bindings
}

output "summary" {
  description = "Summary of created resources"
  value = {
    total_custom_roles   = length(module.hiiretail_iam.custom_roles)
    total_business_units = length(module.hiiretail_iam.business_units)
    total_groups         = length(module.hiiretail_iam.groups)
    total_role_bindings  = length(module.hiiretail_iam.role_bindings)
  }
}
