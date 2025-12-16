# Load YAML configuration
locals {
  config = yamldecode(file("${path.module}/config.yaml"))
}

# Use the HiiRetail IAM module
module "hiiretail_iam" {
  source = "../.."

  custom_roles   = local.config.custom_roles
  business_units = local.config.business_units

  # Enable automatic group and role binding generation
  auto_generate_groups        = true
  auto_generate_role_bindings = true
}
