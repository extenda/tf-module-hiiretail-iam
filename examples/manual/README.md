# Manual Configuration Example

This example demonstrates how to use the module with manual control over groups and role bindings, rather than using automatic generation.

## Overview

This example creates:
- 2 custom roles
- 2 business units
- 3 manually configured groups (with specific members)
- 3 manually configured role bindings

## Use Case

Use manual configuration when you need:
- Full control over group membership
- Custom group naming schemes
- Complex role binding scenarios
- Groups that span multiple business units

## Prerequisites

Set your HiiRetail credentials as environment variables:

```bash
export HIIRETAIL_CLIENT_ID="your-oauth2-client-id"
export HIIRETAIL_CLIENT_SECRET="your-oauth2-client-secret"
export HIIRETAIL_TENANT_ID="your-tenant-id"
```

## Usage

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```

## Key Differences

Unlike the automatic examples, this demonstrates:
- Manual group creation with explicit member lists
- Custom group names (not following the auto-generated pattern)
- Explicit role binding definitions
- More granular control over permissions
