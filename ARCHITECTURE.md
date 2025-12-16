# Architecture Diagrams

This document provides visual representations of how the HiiRetail IAM module works.

## Module Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    HiiRetail IAM Module                     │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  Inputs:                                                    │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐    │
│  │ Custom Roles │  │Business Units│  │    Groups    │    │
│  │  (YAML/HCL)  │  │  (YAML/HCL)  │  │   (Manual)   │    │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘    │
│         │                  │                  │             │
│         └──────────┬───────┴──────────────────┘             │
│                    ▼                                        │
│         ┌──────────────────────┐                           │
│         │   Auto-Generation    │                           │
│         │       Logic          │                           │
│         └──────────┬───────────┘                           │
│                    ▼                                        │
│         ┌──────────────────────┐                           │
│         │    Terraform         │                           │
│         │     Resources        │                           │
│         └──────────┬───────────┘                           │
│                    │                                        │
│  Outputs:          ▼                                        │
│  ┌─────────────────────────────────────┐                  │
│  │  • Custom Roles                     │                  │
│  │  • Business Unit Resources          │                  │
│  │  • Groups (Manual + Auto-generated) │                  │
│  │  • Role Bindings                    │                  │
│  └─────────────────────────────────────┘                  │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Resource Relationship Flow

```
┌──────────────────────┐
│   Custom Roles       │
│                      │
│  • Cashiers          │
│  • StoreManagers     │
└──────────┬───────────┘
           │
           │ defines permissions
           ▼
┌──────────────────────┐
│   Role Bindings      │
│                      │
│  Role → Group        │
│  @ Resource          │
└──────────┬───────────┘
           │
           │ binds to
           ▼
┌──────────────────────┐
│      Groups          │
│                      │
│  • Cashiers-BU-001   │
│  • Cashiers-BU-002   │
└──────────┬───────────┘
           │
           │ scoped to
           ▼
┌──────────────────────┐
│  Business Units      │
│   (Resources)        │
│                      │
│  • BU-001 (Store 1)  │
│  • BU-002 (Store 2)  │
└──────────────────────┘
```

## Automatic Group Generation

### Input
```
Custom Roles:        Business Units:
┌────────────┐      ┌────────────┐
│ Cashiers   │      │   BU-001   │
└────────────┘      └────────────┘
┌────────────┐      ┌────────────┐
│ Managers   │      │   BU-002   │
└────────────┘      └────────────┘
                    ┌────────────┐
                    │   BU-003   │
                    └────────────┘
```

### Auto-Generation Logic
```
Cartesian Product:
2 Roles × 3 Business Units = 6 Groups

For each (Role, BU) pair:
  Create Group: {RoleTitle}-{BUID}
  Create Binding: Role → Group @ BU
```

### Output
```
Generated Groups:           Role Bindings:
┌─────────────────┐        ┌──────────────────────────────┐
│ Cashiers-BU-001 │◄───────┤ Cashiers → Group @ BU-001    │
└─────────────────┘        └──────────────────────────────┘
┌─────────────────┐        ┌──────────────────────────────┐
│ Cashiers-BU-002 │◄───────┤ Cashiers → Group @ BU-002    │
└─────────────────┘        └──────────────────────────────┘
┌─────────────────┐        ┌──────────────────────────────┐
│ Cashiers-BU-003 │◄───────┤ Cashiers → Group @ BU-003    │
└─────────────────┘        └──────────────────────────────┘
┌─────────────────┐        ┌──────────────────────────────┐
│ Managers-BU-001 │◄───────┤ Managers → Group @ BU-001    │
└─────────────────┘        └──────────────────────────────┘
┌─────────────────┐        ┌──────────────────────────────┐
│ Managers-BU-002 │◄───────┤ Managers → Group @ BU-002    │
└─────────────────┘        └──────────────────────────────┘
┌─────────────────┐        ┌──────────────────────────────┐
│ Managers-BU-003 │◄───────┤ Managers → Group @ BU-003    │
└─────────────────┘        └──────────────────────────────┘
```

## Permission Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    Permission Hierarchy                     │
└─────────────────────────────────────────────────────────────┘

User
 │
 └──► Member of Group(s)
        │
        └──► Group has Role Binding(s)
               │
               └──► Role Binding grants Role
                      │
                      └──► Role has Permissions
                             │
                             └──► Permissions scoped to Resource

Example:
────────
User: john@example.com
  └─► Member of: Cashiers-BU-001
        └─► Binding: Cashiers role at BU-001
              └─► Role: Cashiers
                    └─► Permissions:
                          • pos.transactions.create
                          • pos.transactions.read
                          • inventory.products.read
                    └─► Scoped to: BU-001 (Store 001)
```

## Scale Example: 100 Stores

```
Configuration:
──────────────
2 Custom Roles
100 Business Units
Auto-generation: ENABLED

Result:
───────
2    Custom Roles
100  Business Unit Resources
200  Auto-generated Groups (2 × 100)
200  Auto-generated Role Bindings
───────────────────────────────────
502  Total Resources Managed

Configuration Effort:
─────────────────────
Define: 2 roles + 100 business units = 102 definitions
Auto-created: 200 groups + 200 bindings = 400 resources

Manual would require: 502 definitions
Module reduces work by: 79.7%
```

## Data Flow Diagram

```
┌──────────────┐
│  config.yaml │
│   or         │
│  main.tf     │
└──────┬───────┘
       │
       │ yamldecode() / input
       ▼
┌──────────────┐
│   Module     │
│  Variables   │
└──────┬───────┘
       │
       │ locals processing
       ▼
┌──────────────────────┐
│  Auto-Generation     │
│  Logic               │
│  • Create group map  │
│  • Create bindings   │
└──────┬───────────────┘
       │
       │ for_each / count
       ▼
┌──────────────────────┐
│  Terraform           │
│  Resources           │
│  • custom_role       │
│  • resource (BU)     │
│  • group             │
│  • role_binding      │
└──────┬───────────────┘
       │
       │ HiiRetail Provider
       ▼
┌──────────────────────┐
│  HiiRetail API       │
│  (OAuth2 Auth)       │
└──────┬───────────────┘
       │
       │ Creates resources
       ▼
┌──────────────────────┐
│  HiiRetail Tenant    │
│  IAM Resources       │
└──────────────────────┘
```

## Module Modes

### Auto Mode (Default)
```
Input:
  custom_roles     ─┐
  business_units   ─┼─► Module Logic ──► Auto-generates
                    │                    groups & bindings
  auto_generate = true
```

### Manual Mode
```
Input:
  custom_roles       ─┐
  business_units     ─┤
  groups (manual)    ─┼─► Module ──► Creates only
  role_bindings      ─┤              specified resources
  auto_generate = false
```

### Hybrid Mode
```
Input:
  custom_roles            ─┐
  business_units          ─┤
  groups (manual)         ─┼─► Module ──► Auto + Manual
  role_bindings (manual)  ─┤              resources
  auto_generate = true    ─┘
```

## File Structure

```
tf-module-hii-iam/
├── Module Core
│   ├── versions.tf      (Provider requirements)
│   ├── variables.tf     (Input definitions)
│   ├── main.tf          (Resource logic)
│   └── outputs.tf       (Output definitions)
│
├── Documentation
│   ├── README.md        (Main docs)
│   ├── QUICKSTART.md    (Getting started)
│   ├── MODULE_SUMMARY.md (This overview)
│   └── ARCHITECTURE.md  (This file)
│
├── Examples
│   ├── complete/        (YAML-driven)
│   ├── simple/          (Basic inline)
│   └── manual/          (Full control)
│
└── Supporting
    ├── Makefile         (Automation)
    ├── .gitignore       (Git config)
    ├── LICENSE          (MIT)
    ├── CHANGELOG.md     (Version history)
    └── CONTRIBUTING.md  (Dev guide)
```

## State Management

```
┌────────────────────┐
│  Terraform State   │
├────────────────────┤
│                    │
│  Module Resources: │
│  ├─ custom_roles   │
│  ├─ resources      │
│  ├─ groups         │
│  └─ role_bindings  │
│                    │
│  Tracked:          │
│  • Resource IDs    │
│  • Attributes      │
│  • Dependencies    │
│  • Metadata        │
│                    │
└────────────────────┘
         │
         │ terraform apply
         ▼
┌────────────────────┐
│   HiiRetail API    │
│   Actual State     │
└────────────────────┘
```

## CI/CD Integration

```
┌──────────────┐
│  Git Repo    │
│  (config.yaml)│
└──────┬───────┘
       │
       │ git push
       ▼
┌──────────────┐
│   CI/CD      │
│   Pipeline   │
│              │
│ 1. Validate  │
│ 2. Plan      │
│ 3. Review    │
│ 4. Apply     │
└──────┬───────┘
       │
       │ terraform apply
       ▼
┌──────────────┐
│  HiiRetail   │
│   Tenant     │
└──────────────┘
```

---

These diagrams illustrate the architecture and data flow of the HiiRetail IAM Terraform module. For more details, see the [README](README.md) and [examples](examples/).
