# HiiRetail IAM Terraform Module

A Terraform module for managing HiiRetail IAM resources including custom roles, groups, business unit resources, and role bindings. This module simplifies the management of hundreds of IAM resources across multiple business units (stores) in a tenant.

## Features

- **Custom Role Management**: Create and manage custom IAM roles with specific permissions
- **Business Unit Resources**: Define business units as IAM resources for granular access control
- **Automatic Group Generation**: Automatically generates groups based on business units and custom roles (e.g., `Financial Users-001`, `Financial Managers-001`)
- **Role Binding Automation**: Automatically creates role bindings that connect custom roles to groups at specific business unit resources
- **YAML-Driven Configuration**: Easy to manage with YAML configuration files for bulk operations
- **Flexible Configuration**: Supports both automatic generation and manual configuration modes

## Prerequisites

- Terraform >= 1.0
- HiiRetail provider credentials set as environment variables:
  - `HIIRETAIL_CLIENT_ID`: OAuth2 client ID
  - `HIIRETAIL_CLIENT_SECRET`: OAuth2 client secret
  - `HIIRETAIL_TENANT_ID`: Tenant identifier

## Usage

### Basic Example

```hcl
module "hiiretail_iam" {
  source = "./tf-module-hii-iam"

  custom_roles = {
    financialusers = {
      title       = "Financial Users"
      description = "Role for financial users with standard financial operations access"
      stage       = "GA"
      permissions = [
        {
          id = "hss.reconciliation.get"
        },
        {
          id = "hss.reconciliation.list"
        },
        {
          id = "rec.counts.count"
        }
      ]
    }
    financialmanagers = {
      title       = "Financial Managers"
      description = "Role for financial managers with full financial operations access"
      stage       = "GA"
      permissions = [
        {
          id = "hss.reconciliation.get"
        },
        {
          id = "hss.reconciliation.list"
        },
        {
          id = "cmm.audits.get"
        },
        {
          id = "cmm.repositories.get"
        }
      ]
    }
  }

  business_units = {
    "001" = {
      name = "Store 001 - Downtown"
      id   = "BU-001"
      props = {
        location = "downtown"
        region   = "north"
      }
    }
    "002" = {
      name = "Store 002 - Uptown"
      id   = "BU-002"
      props = {
        location = "uptown"
        region   = "north"
      }
    }
  }

  # Enable automatic group and role binding generation
  auto_generate_groups         = true
  auto_generate_role_bindings = true
}
```

This configuration will automatically create:
- 2 custom roles: `Financial Users` and `Financial Managers`
- 2 business unit resources: `BU-001` and `BU-002`
- 4 groups: `Financial Users-BU-001`, `Financial Managers-BU-001`, `Financial Users-BU-002`, `Financial Managers-BU-002`
- 4 role bindings connecting each role to each group at their respective business units

### YAML-Driven Configuration

For easier management of large numbers of resources, you can use YAML files:

```hcl
locals {
  config = yamldecode(file("${path.module}/config.yaml"))
}

module "hiiretail_iam" {
  source = "./tf-module-hii-iam"

  custom_roles                = local.config.custom_roles
  business_units              = local.config.business_units
  auto_generate_groups        = true
  auto_generate_role_bindings = true
}
```

See the [examples](./examples/) directory for complete working examples.

## Input Variables

### Required Variables

None. All variables have defaults, though you'll typically want to configure at least `custom_roles` and `business_units`.

### Optional Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `custom_roles` | Map of custom roles to create with their permissions | `map(object)` | `{}` |
| `business_units` | Map of Business Units (stores) to create as IAM resources | `map(object)` | `{}` |
| `groups` | Map of manually specified groups to create | `map(object)` | `{}` |
| `role_bindings` | List of manually specified role bindings to create | `list(object)` | `[]` |
| `auto_generate_groups` | Automatically generate groups based on business units and custom roles | `bool` | `true` |
| `auto_generate_role_bindings` | Automatically generate role bindings for auto-generated groups | `bool` | `true` |

### Variable Details

#### `custom_roles`

```hcl
type = map(object({
  title       = string
  description = optional(string, "")
  stage       = optional(string, "GA") # ALPHA, BETA, or GA
  permissions = list(object({
    id         = string
    attributes = optional(map(string), {})
  }))
}))
```

#### `business_units`

```hcl
type = map(object({
  name  = string
  id    = optional(string, null) # If not provided, will use the key
  props = optional(map(string), {})
}))
```

#### `groups`

Used only when `auto_generate_groups = false`.

```hcl
type = map(object({
  description = optional(string, "")
  members     = optional(list(string), [])
}))
```

#### `role_bindings`

Used for manual role bindings or additional bindings beyond auto-generated ones.

```hcl
type = list(object({
  group_id    = string
  role_id     = string
  is_custom   = bool
  bindings    = optional(list(string), [])
  description = optional(string, "")
  condition   = optional(string, null)
}))
```

## Outputs

| Name | Description |
|------|-------------|
| `custom_roles` | Map of created custom roles with their IDs and details |
| `business_units` | Map of created Business Unit resources with their IDs |
| `groups` | Map of all created groups (manual and auto-generated) |
| `role_bindings` | List of all created role bindings |
| `auto_generated_groups_map` | Map showing the relationship between auto-generated groups, business units, and roles |

## How It Works

### Automatic Group Generation

When `auto_generate_groups = true`, the module creates a cartesian product of all custom roles and business units. For example:

- Custom Roles: `Financial Users`, `Financial Managers`
- Business Units: `001`, `002`, `003`
- Generated Groups: `Financial Users-001`, `Financial Users-002`, `Financial Users-003`, `Financial Managers-001`, `Financial Managers-002`, `Financial Managers-003`

### Automatic Role Binding

When `auto_generate_role_bindings = true`, the module automatically creates role bindings that:
1. Bind each custom role to its corresponding auto-generated group
2. Scope the binding to the specific business unit resource
3. Create appropriate descriptions for traceability

### Manual Mode

Set both `auto_generate_groups` and `auto_generate_role_bindings` to `false` to manually specify all groups and role bindings. This provides full control but requires more configuration.

## Examples

See the [examples](./examples/) directory for:
- **complete**: Full example with YAML configuration for multiple stores
- **simple**: Basic example with minimal configuration
- **manual**: Example using manual group and role binding configuration

## Authentication

This module assumes authentication is handled via environment variables:

```bash
export HIIRETAIL_CLIENT_ID="your-oauth2-client-id"
export HIIRETAIL_CLIENT_SECRET="your-oauth2-client-secret"
export HIIRETAIL_TENANT_ID="your-tenant-id"
```

See the [HiiRetail Provider Authentication Guide](https://registry.terraform.io/providers/extenda/hiiretail/latest/docs/guides/authentication) for more details.

## Best Practices

1. **Use YAML for Configuration**: For managing many resources, use YAML files for better readability
2. **Consistent Naming**: Use consistent naming patterns for business unit IDs
3. **Version Control**: Keep YAML configuration files in version control
4. **Stage Progression**: Use `stage` attribute to manage role lifecycle (ALPHA → BETA → GA)
5. **Permission Granularity**: Define fine-grained permissions based on actual needs
6. **Documentation**: Document custom permissions and their purpose

## Terraform Best Practices Applied

- ✅ Semantic versioning constraints
- ✅ Input validation
- ✅ Comprehensive outputs
- ✅ Optional variable defaults
- ✅ Resource dependencies properly declared
- ✅ DRY principles with locals and dynamic blocks
- ✅ Sensitive data handling via environment variables
- ✅ Clear variable and output descriptions

## Resources Managed

This module manages the following HiiRetail resources:

- `hiiretail_iam_custom_role`: Custom IAM roles with specific permissions
- `hiiretail_iam_resource`: Business unit resources for access scoping
- `hiiretail_iam_group`: User groups for permission assignment
- `hiiretail_iam_role_binding`: Bindings between roles, groups, and resources

## License

MIT License - See LICENSE file for details

## Support

For issues and questions:
- Provider Issues: [terraform-provider-hiiretail](https://github.com/extenda/terraform-provider-hiiretail/issues)
- Module Issues: Create an issue in this repository
