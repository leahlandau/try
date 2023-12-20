# start secret
variable subscription_id {
  type        = string
}


variable DOCKER_REGISTRY_SERVER_PASSWORD {
  type        = string
}

variable DOCKER_REGISTRY_SERVER_USERNAME {
  type        = string
}

variable DOCKER_REGISTRY_SERVER_URL {
  type        = string
}

# end secrets

variable rg_name {
  type        = string
  default = "rg-manage-subscrioptions"
}

variable rg_location {  
  type        = string
  default = "West Europe"
}


variable vnet_name {
  type        = string
  default = "vnet-manage-subscriptions"
}

variable address_space {
  type        = list
  default = ["10.1.0.0/16"]
}

variable dns_servers {
  type        = list
  default = []
}

variable subnet_name {
  type        = string
  default = "snet-manage-subscriptions"
}

variable subnet_address_prefix {
  type        = list
  default = ["10.1.1.0/24"]
}

variable vnet_storage_account_name {
  type        = string
  default =  "stmanageaubscriptions"
}

variable app_service_plan_name{
  type = string
  default =  "app-subscriptions"
}

variable function_app_name {
  type        = string
  default =  "func-subscriptions-automation"
}

variable logic_app_workflow_name {
  type        = string
  default = "logic-app-subscription-management"
}


variable key_vault_name {
  type        = string
  default = "kv-manage-automation"
}

variable key_vault_uri {
  type        = string
  default     = "https://kv-manage-automation.vault.azure.net"
}

variable key_vault_certificate_permissions {
  type        = list
  default = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore"]
}

variable key_vault_key_permissions {
  type        = list
  default = ["Create","Get"]
}

variable key_vault_secret_permissions {
  type        = list
  default = ["Get","Set","Delete","Purge","Recover"]
}

variable key_vault_storage_permissions {
  type        = list
  default =  ["Get", ]
}

variable key_vault_secret_name {
  type        = string
  default     = "CONNECTION-STRING"
}

variable linux_fx_version {
  type = string
  default = "DOCKER|mcr.microsoft.com/azure-functions/dotnet:4-appservice-quickstart"
}