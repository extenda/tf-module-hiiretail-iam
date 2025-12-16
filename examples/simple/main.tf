module "hiiretail_iam" {
  source = "../.."

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
      description = "Role for store manager staff members"
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

  # Enable automatic group and role binding generation
  auto_generate_groups        = true
  auto_generate_role_bindings = true
}
