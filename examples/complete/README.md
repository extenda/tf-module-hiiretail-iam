# Complete Example - YAML-Driven Configuration

This example demonstrates a complete implementation using YAML configuration files to manage IAM resources for multiple stores.

## Overview

This example creates:
- 2 custom roles (Cashiers and StoreManagers) with different permission sets
- 5 business units (stores)
- 10 auto-generated groups (2 roles × 5 stores)
- 10 auto-generated role bindings

## Files

- `main.tf`: Terraform configuration using the module
- `config.yaml`: YAML configuration for roles and business units
- `terraform.tfvars.example`: Example variables file
- `outputs.tf`: Output definitions
- `versions.tf`: Provider requirements

## Prerequisites

Set your HiiRetail credentials as environment variables:

```bash
export HIIRETAIL_CLIENT_ID="your-oauth2-client-id"
export HIIRETAIL_CLIENT_SECRET="your-oauth2-client-secret"
export HIIRETAIL_TENANT_ID="your-tenant-id"
```

## Usage

1. Copy the example tfvars file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the plan:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Customization

Edit `config.yaml` to:
- Add or remove custom roles
- Modify permissions for existing roles
- Add or remove business units
- Update business unit properties

The module will automatically generate the appropriate groups and role bindings.
