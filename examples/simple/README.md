# Simple Example - Inline Configuration

This example demonstrates a minimal implementation using inline configuration in Terraform.

## Overview

This example creates:
- 2 custom roles (Cashiers and StoreManagers)
- 2 business units
- 4 auto-generated groups
- 4 auto-generated role bindings

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

## What Gets Created

The module will automatically create:
- Groups: `Cashiers-BU-001`, `Cashiers-BU-002`, `StoreManagers-BU-001`, `StoreManagers-BU-002`
- Role bindings for each group scoped to their respective business unit
