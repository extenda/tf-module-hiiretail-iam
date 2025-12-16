# Quick Start Guide

Get started with the HiiRetail IAM Terraform module in minutes.

## Prerequisites

1. **Terraform Installation**
   ```bash
   # Verify Terraform is installed
   terraform version
   # Should show >= 1.0
   ```

2. **HiiRetail Credentials**
   
   Obtain from your HiiRetail administrator:
   - OAuth2 Client ID
   - OAuth2 Client Secret
   - Tenant ID

3. **Set Environment Variables**
   ```bash
   export HIIRETAIL_CLIENT_ID="your-oauth2-client-id"
   export HIIRETAIL_CLIENT_SECRET="your-oauth2-client-secret"
   export HIIRETAIL_TENANT_ID="your-tenant-id"
   ```

## 5-Minute Setup

### Option 1: Use the Simple Example

1. **Navigate to the simple example:**
   ```bash
   cd examples/simple
   ```

2. **Initialize Terraform:**
   ```bash
   terraform init
   ```

3. **Review what will be created:**
   ```bash
   terraform plan
   ```

4. **Apply the configuration:**
   ```bash
   terraform apply
   ```

5. **View the results:**
   ```bash
   terraform output
   ```

### Option 2: YAML-Driven Configuration (Recommended for Production)

1. **Navigate to the complete example:**
   ```bash
   cd examples/complete
   ```

2. **Edit `config.yaml` to match your needs:**
   ```bash
   vi config.yaml
   ```

3. **Initialize and apply:**
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

## Understanding What Gets Created

### With 2 Custom Roles and 2 Business Units

The module automatically creates:

```
Custom Roles (2):
├── Cashiers (custom.cashiers)
└── StoreManagers (custom.storemanagers)

Business Units (2):
├── BU-001 (Store 001)
└── BU-002 (Store 002)

Auto-Generated Groups (4):
├── Cashiers-BU-001
├── Cashiers-BU-002
├── StoreManagers-BU-001
└── StoreManagers-BU-002

Role Bindings (4):
├── Cashiers → Cashiers-BU-001 @ BU-001
├── Cashiers → Cashiers-BU-002 @ BU-002
├── StoreManagers → StoreManagers-BU-001 @ BU-001
└── StoreManagers → StoreManagers-BU-002 @ BU-002
```

## Common Tasks

### Adding a New Store

Edit your configuration (YAML or HCL):

```yaml
# config.yaml
business_units:
  "003":
    name: "Store 003 - New Location"
    id: "BU-003"
```

Then apply:
```bash
terraform apply
```

Groups and role bindings are created automatically!

### Adding a New Role

```yaml
# config.yaml
custom_roles:
  assistantmanagers:
    title: "AssistantManagers"
    description: "Role for assistant managers"
    stage: "GA"
    permissions:
      - id: "pos.transactions.read"
      - id: "inventory.products.read"
```

Apply changes:
```bash
terraform apply
```

### Viewing Current State

```bash
# See all outputs
terraform output

# See specific output
terraform output groups

# See state in JSON
terraform show -json
```

### Destroying Resources

```bash
# Preview what will be destroyed
terraform plan -destroy

# Destroy all resources
terraform destroy
```

## Scaling Up

### Managing 100+ Stores

1. **Use YAML configuration** for maintainability
2. **Generate YAML from your source of truth** (database, spreadsheet)
3. **Version control your config.yaml**
4. **Use CI/CD** for automated deployments

Example script to generate YAML:

```python
import yaml

# Load stores from your database
stores = load_stores_from_database()

config = {
    'business_units': {
        store.id: {
            'name': store.name,
            'id': f'BU-{store.id}',
            'props': {
                'location': store.location,
                'region': store.region
            }
        }
        for store in stores
    }
}

with open('config.yaml', 'w') as f:
    yaml.dump(config, f)
```

## Troubleshooting

### Authentication Errors

```bash
# Verify environment variables are set
echo $HIIRETAIL_CLIENT_ID
echo $HIIRETAIL_TENANT_ID

# Enable debug logging
export TF_LOG=DEBUG
terraform plan
```

### Validation Errors

```bash
# Validate configuration
terraform validate

# Format files
terraform fmt -recursive

# Check for syntax errors
terraform plan
```

### Provider Not Found

If you see provider errors, ensure you're using Terraform 1.0 or later:

```bash
terraform version
```

## Best Practices

1. ✅ **Always review the plan** before applying
2. ✅ **Use version control** for your configuration
3. ✅ **Test in a dev environment** first
4. ✅ **Use meaningful resource names**
5. ✅ **Document custom permissions**
6. ✅ **Keep credentials secure** (environment variables only)

## Getting Help

- 📖 Read the [main README](../README.md)
- 📝 Check the [examples](../examples/)
- 🐛 [Report issues](https://github.com/extenda/tf-module-hii-iam/issues)
- 📚 [HiiRetail Provider Docs](https://registry.terraform.io/providers/extenda/hiiretail/latest/docs)

## Next Steps

1. Review the [complete example](../examples/complete/) for production patterns
2. Customize roles and permissions for your needs
3. Integrate with your CI/CD pipeline
4. Set up remote state management (S3, Terraform Cloud, etc.)

Happy Terraforming! 🚀
