# HiiRetail IAM Module
# This module manages HiiRetail IAM resources including custom roles, groups, resources, and role bindings

# Create custom roles
resource "hiiretail_iam_custom_role" "this" {
  for_each = var.custom_roles

  id          = "custom.${each.key}"
  name        = each.key
  title       = each.value.title
  description = each.value.description
  stage       = each.value.stage

  dynamic "permissions" {
    for_each = each.value.permissions
    content {
      id         = permissions.value.id
      attributes = permissions.value.attributes
    }
  }
}

# Create Business Unit resources
resource "hiiretail_iam_resource" "business_units" {
  for_each = var.business_units

  id    = each.value.id != null ? each.value.id : each.key
  name  = each.value.name
  props = length(each.value.props) > 0 ? jsonencode(each.value.props) : null
}

# Create manually specified groups
resource "hiiretail_iam_group" "manual" {
  for_each = var.auto_generate_groups ? {} : var.groups

  name        = each.key
  description = each.value.description
  members     = toset(each.value.members)
}

# Auto-generate groups based on business units and custom roles
# Creates groups like "Cashiers-001", "StoreManagers-001", etc.
locals {
  # Create a cartesian product of business units and custom roles
  auto_generated_groups = var.auto_generate_groups ? {
    for combo in flatten([
      for bu_key, bu_value in var.business_units : [
        for role_key, role_value in var.custom_roles : {
          group_name = "${role_value.title}-${bu_value.id != null ? bu_value.id : bu_key}"
          bu_id      = bu_value.id != null ? bu_value.id : bu_key
          bu_name    = bu_value.name
          role_id    = "custom.${role_key}"
          role_name  = role_key
          role_title = role_value.title
        }
      ]
    ]) : combo.group_name => combo
  } : {}

  # Merge manual and auto-generated groups for use in role bindings
  all_groups = merge(
    { for k, v in hiiretail_iam_group.manual : k => v.id },
    { for k, v in hiiretail_iam_group.auto : k => v.id }
  )

  # Auto-generate role bindings for auto-generated groups
  auto_generated_role_bindings = var.auto_generate_role_bindings && var.auto_generate_groups ? [
    for group_key, group_data in local.auto_generated_groups : {
      group_id    = hiiretail_iam_group.auto[group_key].id
      role_id     = group_data.role_id
      is_custom   = true
      bindings    = [hiiretail_iam_resource.business_units[group_data.bu_id].id]
      description = "Auto-generated binding for ${group_data.role_title} at ${group_data.bu_name}"
      condition   = null
    }
  ] : []

  # Merge manual and auto-generated role bindings
  all_role_bindings = concat(var.role_bindings, local.auto_generated_role_bindings)
}

# Create auto-generated groups
resource "hiiretail_iam_group" "auto" {
  for_each = local.auto_generated_groups

  name        = each.key
  description = "Auto-generated group for ${each.value.role_title} at ${each.value.bu_name}"
  members     = []
}

# Create role bindings
resource "hiiretail_iam_role_binding" "this" {
  count = length(local.all_role_bindings)

  group_id    = local.all_role_bindings[count.index].group_id
  role_id     = local.all_role_bindings[count.index].role_id
  is_custom   = local.all_role_bindings[count.index].is_custom
  bindings    = local.all_role_bindings[count.index].bindings
  description = local.all_role_bindings[count.index].description
  condition   = local.all_role_bindings[count.index].condition

  depends_on = [
    hiiretail_iam_custom_role.this,
    hiiretail_iam_resource.business_units,
    hiiretail_iam_group.manual,
    hiiretail_iam_group.auto
  ]
}
