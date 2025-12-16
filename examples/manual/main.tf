module "hiiretail_iam" {
  source = "../.."

  # Define custom roles
  custom_roles = {
    cashiers = {
      title       = "Cashiers"
      description = "Role for cashier staff members"
      stage       = "GA"
      permissions = [
        {
          id = "pos.transactions.create"
        },
        {
          id = "pos.transactions.read"
        },
        {
          id = "inventory.products.read"
        }
      ]
    }

    storemanagers = {
      title       = "StoreManagers"
      description = "Role for store managers"
      stage       = "GA"
      permissions = [
        {
          id = "pos.transactions.create"
        },
        {
          id = "pos.transactions.read"
        },
        {
          id = "pos.reports.read"
        },
        {
          id = "inventory.products.read"
        },
        {
          id = "inventory.products.update"
        },
        {
          id = "staff.management.read"
        }
      ]
    }
  }

  # Define business units
  business_units = {
    "001" = {
      name = "Store 001 - Downtown"
      id   = "BU-001"
    }
    "002" = {
      name = "Store 002 - Uptown"
      id   = "BU-002"
    }
  }

  # Manually define groups with specific members
  groups = {
    "downtown-cashiers" = {
      description = "Cashier staff for downtown store"
      members = [
        "user:cashier1@example.com",
        "user:cashier2@example.com",
        "user:cashier3@example.com"
      ]
    }

    "uptown-cashiers" = {
      description = "Cashier staff for uptown store"
      members = [
        "user:cashier4@example.com",
        "user:cashier5@example.com"
      ]
    }

    "regional-managers" = {
      description = "Store managers for both locations"
      members = [
        "user:manager1@example.com",
        "user:manager2@example.com"
      ]
    }
  }

  # Manually define role bindings
  role_bindings = [
    # Bind cashier role to downtown cashiers at downtown store
    {
      group_id    = "downtown-cashiers"
      role_id     = "custom.cashiers"
      is_custom   = true
      bindings    = ["BU-001"]
      description = "Cashiers access for downtown store"
    },
    # Bind cashier role to uptown cashiers at uptown store
    {
      group_id    = "uptown-cashiers"
      role_id     = "custom.cashiers"
      is_custom   = true
      bindings    = ["BU-002"]
      description = "Cashiers access for uptown store"
    },
    # Bind manager role to regional managers at both stores
    {
      group_id    = "regional-managers"
      role_id     = "custom.storemanagers"
      is_custom   = true
      bindings    = ["BU-001", "BU-002"]
      description = "Manager access for both stores"
    }
  ]

  # Disable automatic generation
  auto_generate_groups        = false
  auto_generate_role_bindings = false
}
