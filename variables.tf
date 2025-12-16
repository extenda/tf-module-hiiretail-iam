variable "custom_roles" {
  description = "Map of custom roles to create with their permissions"
  type = map(object({
    title       = string
    description = optional(string, "")
    stage       = optional(string, "GA")
    permissions = list(object({
      id         = string
      attributes = optional(map(string), {})
    }))
  }))
  default = {}

  validation {
    condition     = alltrue([for k, v in var.custom_roles : contains(["ALPHA", "BETA", "GA"], v.stage)])
    error_message = "Stage must be one of: ALPHA, BETA, or GA."
  }
}

variable "business_units" {
  description = "Map of Business Units (stores) to create as IAM resources"
  type = map(object({
    name  = string
    id    = optional(string, null) # If not provided, will use the key
    props = optional(map(string), {})
  }))
  default = {}
}

variable "groups" {
  description = "Map of groups to create with their members"
  type = map(object({
    description = optional(string, "")
    members     = optional(list(string), [])
  }))
  default = {}
}

variable "role_bindings" {
  description = "List of role bindings to create, binding roles to groups at specific resources"
  type = list(object({
    group_id    = string
    role_id     = string
    is_custom   = bool
    bindings    = optional(list(string), []) # List of resource IDs
    description = optional(string, "")
    condition   = optional(string, null)
  }))
  default = []
}

variable "auto_generate_groups" {
  description = "Automatically generate groups based on business units and custom roles"
  type        = bool
  default     = true
}

variable "auto_generate_role_bindings" {
  description = "Automatically generate role bindings for auto-generated groups"
  type        = bool
  default     = true
}
