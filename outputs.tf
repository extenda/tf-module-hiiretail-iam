output "custom_roles" {
  description = "Map of created custom roles with their IDs and details"
  value = {
    for k, v in hiiretail_iam_custom_role.this : k => {
      id          = v.id
      name        = v.name
      title       = v.title
      description = v.description
      stage       = v.stage
      created_at  = v.created_at
      updated_at  = v.updated_at
    }
  }
}

output "business_units" {
  description = "Map of created Business Unit resources with their IDs"
  value = {
    for k, v in hiiretail_iam_resource.business_units : k => {
      id        = v.id
      name      = v.name
      tenant_id = v.tenant_id
    }
  }
}

output "groups" {
  description = "Map of all created groups (manual and auto-generated) with their IDs"
  value = merge(
    {
      for k, v in hiiretail_iam_group.manual : k => {
        id          = v.id
        name        = v.name
        description = v.description
        type        = "manual"
      }
    },
    {
      for k, v in hiiretail_iam_group.auto : k => {
        id          = v.id
        name        = v.name
        description = v.description
        type        = "auto-generated"
      }
    }
  )
}

output "role_bindings" {
  description = "List of all created role bindings with their details"
  value = [
    for rb in hiiretail_iam_role_binding.this : {
      id          = rb.id
      group_id    = rb.group_id
      role_id     = rb.role_id
      is_custom   = rb.is_custom
      bindings    = rb.bindings
      description = rb.description
    }
  ]
}

output "auto_generated_groups_map" {
  description = "Map showing the relationship between auto-generated groups, business units, and roles"
  value       = local.auto_generated_groups
}
