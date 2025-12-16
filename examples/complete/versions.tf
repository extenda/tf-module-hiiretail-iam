terraform {
  required_version = ">= 1.0"

  required_providers {
    hiiretail = {
      source  = "extenda/hiiretail"
      version = ">= 0.1.0"
    }
  }
}

# Provider configuration uses environment variables
provider "hiiretail" {
  # Authentication via environment variables:
  # - HIIRETAIL_CLIENT_ID
  # - HIIRETAIL_CLIENT_SECRET
  # - HIIRETAIL_TENANT_ID
}
