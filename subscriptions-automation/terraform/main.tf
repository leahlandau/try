terraform {
  backend "azurerm" {
    resource_group_name      = "NetworkWatcherRG"
    storage_account_name     = "myfirsttrail"
    container_name           = "terraformstste-subscriptions"
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



resource "azurerm_logic_app_workflow" "logic_app_workflow" {
  name                =  var.logic_app_workflow_name
  location            = azurerm_resource_group.vnet_resource_group.location
  resource_group_name = azurerm_resource_group.vnet_resource_group.name
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
  name                      =  var.function_app_name
  location                  = azurerm_storage_account.vnet_storage_account.location
  resource_group_name       = azurerm_storage_account.vnet_storage_account.resource_group_name
  app_service_plan_id       = azurerm_app_service_plan.app_service_plan.id
  storage_account_name      = azurerm_storage_account.vnet_storage_account.name
  storage_account_access_key = azurerm_storage_account.vnet_storage_account.primary_access_key
  version                   = "~4"

  app_settings ={
    FUNCTIONS_WORKER_RUNTIME = "python"
    NUM_OF_MONTHS = " "
    COST = " "
    TABLE_SUBSCRIPTIONS_TO_DELETE =" "
    TABLE_DELETED_SUBSCRIPTIONS = " "
    TABLE_SUBSCRIPTIONS_MANAGERS = " "
    TABLE_EMAILS = " "
    HTTP_TRIGGER_URL = " "
    RECIPIENT_EMAIL =" "
    SHELIS_EMAIL = " "
    TAG_NAME = " "
    SECRET = var.key_vault_secret_name
    KEYVAULT_NAME = var.key_vault_name
    KEYVAULT_URI = var.key_vault_uri
    https_only                          = true
    DOCKER_REGISTRY_SERVER_URL          = var.DOCKER_REGISTRY_SERVER_URL
    DOCKER_REGISTRY_SERVER_USERNAME     = var.DOCKER_REGISTRY_SERVER_USERNAME
    DOCKER_REGISTRY_SERVER_PASSWORD     = var.DOCKER_REGISTRY_SERVER_PASSWORD
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = false
  }
  
  site_config {
    always_on         = true
    linux_fx_version  = var.linux_fx_version 
  }

  identity {
    type = "SystemAssigned"
  }
  
}