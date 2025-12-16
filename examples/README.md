# Examples

This directory contains working examples demonstrating different ways to use the HiiRetail IAM Terraform module.

## Available Examples

### [Complete](./complete/)
Full-featured example using YAML configuration to manage IAM resources for multiple stores. This is the recommended approach for production use with many resources.

**Features:**
- YAML-driven configuration
- 2 custom roles with comprehensive permissions
- 5 business units (stores)
- Auto-generated groups and role bindings
- Detailed output examples

**Best for:** Production deployments managing many stores

### [Simple](./simple/)
Minimal example using inline Terraform configuration. Great for getting started quickly.

**Features:**
- Inline Terraform configuration
- 2 custom roles with basic permissions
- 2 business units
- Auto-generated groups and role bindings

**Best for:** Learning the module, quick testing, small deployments

### [Manual](./manual/)
Example demonstrating manual control over groups and role bindings without automatic generation.

**Features:**
- Manual group creation with explicit members
- Custom group naming
- Explicit role binding definitions
- Full control over relationships

**Best for:** Complex scenarios requiring fine-grained control

## Quick Start

1. Choose an example directory
2. Navigate to that directory
3. Set environment variables:
   ```bash
   export HIIRETAIL_CLIENT_ID="your-oauth2-client-id"
   export HIIRETAIL_CLIENT_SECRET="your-oauth2-client-secret"
   export HIIRETAIL_TENANT_ID="your-tenant-id"
   ```
4. Run Terraform:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Comparison

| Feature | Complete | Simple | Manual |
|---------|----------|--------|--------|
| Configuration Style | YAML | Inline | Inline |
| Auto Groups | ✅ | ✅ | ❌ |
| Auto Bindings | ✅ | ✅ | ❌ |
| Custom Members | ❌ | ❌ | ✅ |
| Scalability | High | Medium | Low |
| Complexity | Low | Low | High |
| Flexibility | Medium | Low | High |

## Common Patterns

### Adding a New Store

**Complete/Simple (Auto mode):**
Just add the business unit to your configuration:
```yaml
business_units:
  "006":
    name: "Store 006 - New Location"
    id: "BU-006"
```

Groups and role bindings are created automatically.

**Manual mode:**
Add the business unit, groups, and role bindings explicitly:
```hcl
business_units = {
  "006" = {
    name = "Store 006 - New Location"
    id   = "BU-006"
  }
}

groups = {
  "store006-cashiers" = {
    description = "Cashiers for store 006"
  }
}

role_bindings = [
  {
    group_id  = "store006-cashiers"
    role_id   = "custom.cashiers"
    is_custom = true
    bindings  = ["BU-006"]
  }
]
```

### Adding a New Role

Add the role definition to `custom_roles`. In auto mode, groups and bindings are created automatically for all existing business units.

### Scaling to Hundreds of Stores

Use the **Complete** example with YAML configuration:
1. Maintain store definitions in `config.yaml`
2. Use scripts to generate YAML from your source of truth (database, CSV, etc.)
3. Version control the YAML file
4. Let Terraform manage the infrastructure

## Testing

Each example can be tested independently:

```bash
cd examples/complete
terraform init
terraform plan
# Review the plan carefully
terraform apply
# Verify the resources
terraform destroy  # Clean up when done
```

## Need Help?

- Review the main [README](../README.md) for module documentation
- Check the [HiiRetail Provider documentation](https://registry.terraform.io/providers/extenda/hiiretail/latest/docs)
- Open an issue for questions or problems
