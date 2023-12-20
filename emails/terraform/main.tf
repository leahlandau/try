terraform {
  backend "azurerm" {
    resource_group_name      = "NetworkWatcherRG"
    storage_account_name     = "myfirsttrail"
    container_name           = "terraformstate-emails"
    key                      = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }

  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "vnet_resource_group" {
  name     = var.rg_name
  location = var.rg_location
}


resource "azurerm_virtual_network" "virtual_network" {
  name                = var.vnet_name
  location            = azurerm_resource_group.vnet_resource_group.location
  resource_group_name = azurerm_resource_group.vnet_resource_group.name
  address_space       = var.address_space
  dns_servers         = var.dns_servers
}

resource "azurerm_subnet" "vnet_subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.vnet_resource_group.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = var.subnet_address_prefix
  service_endpoints = ["Microsoft.Storage"]
}


resource "azurerm_storage_account" "vnet_storage_account" {
  name                = var.vnet_storage_account_name
  resource_group_name = azurerm_resource_group.vnet_resource_group.name

  location                 = azurerm_resource_group.vnet_resource_group.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action             = "Deny"
    virtual_network_subnet_ids = [azurerm_subnet.vnet_subnet.id]
  }
}

data "azurerm_client_config" "current_client" {}

resource "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  location            = "West Europe"
  resource_group_name = azurerm_storage_account.vnet_storage_account.resource_group_name
  soft_delete_retention_days  = 7
  tenant_id           = data.azurerm_client_config.current_client.tenant_id
  sku_name            = var.key_vault_sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.current_client.tenant_id
    object_id = data.azurerm_client_config.current_client.object_id

    certificate_permissions = var.key_vault_certificate_permissions

    key_permissions = var.key_vault_key_permissions

    secret_permissions = var.key_vault_secret_permissions

    storage_permissions = var.key_vault_storage_permissions
  }
}

resource "azurerm_key_vault_secret" "key_vault_secret" {
  name         = var.key_vault_secret_name
  value        = azurerm_storage_account.vnet_storage_account.primary_connection_string
  key_vault_id = azurerm_key_vault.key_vault.id
}



resource "azurerm_app_service_plan" "app_service_plan" {
  name                = var.app_service_plan_name
  location            = azurerm_storage_account.vnet_storage_account.location
  resource_group_name = azurerm_storage_account.vnet_storage_account.resource_group_name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Premium"
    size = "P1V2"
  }
  
}


resource "azurerm_function_app" "function_app" {
  name                      = var.function_app_name
  location                  = azurerm_storage_account.vnet_storage_account.location
  resource_group_name       = azurerm_storage_account.vnet_storage_account.resource_group_name
  app_service_plan_id       = azurerm_app_service_plan.app_service_plan.id
  storage_account_name      = azurerm_storage_account.vnet_storage_account.name
  storage_account_access_key = azurerm_storage_account.vnet_storage_account.primary_access_key
  os_type                   = "linux"
  version                   = "~4"

  app_settings = {
    FUNCTIONS_WORKER_RUNTIME = "python"
    EMAIL_SENDER = " "
    SENDER_EMAIL_PASSWORD =" "
    SMTP_HOST = " "
    SMTP_PORT = " "
    SECRET = azurerm_key_vault_secret.key_vault_secret.name
    KEYVAULT_NAME = azurerm_key_vault.key_vault.name
    KEYVAULT_URI = azurerm_key_vault.key_vault.vault_uri
    https_only                                = true
    DOCKER_REGISTRY_SERVER_URL                = var.DOCKER_REGISTRY_SERVER_URL 
    DOCKER_REGISTRY_SERVER_USERNAME           = var.DOCKER_REGISTRY_SERVER_USERNAME
    DOCKER_REGISTRY_SERVER_PASSWORD           = var.DOCKER_REGISTRY_SERVER_PASSWORD 
    WEBSITES_ENABLE_APP_SERVICE_STORAGE       = false
  }
  
  site_config {
    linux_fx_version = "python|3.11"
  }

  site_config {
    always_on         = true
    linux_fx_version  = var.linux_fx_version
  }
  
}