terraform {
  required_providers {
    databricks = {
      source = "databrickslabs/databricks"
      version = "0.3.10"
    }
    azurerm =  "~> 2.33"
    random = "~> 2.2"
  }
}

provider "azurerm" {
  features {}
}

variable "region" {
  type = string
  default = "australiaeast"
}

resource "random_string" "naming" {
  special = false
  upper   = false
  length  = 6
}

data "azurerm_client_config" "current" {
}

data "external" "me" {
  program = ["az", "account", "show", "--query", "user"]
}

locals {
  prefix = "ywdatabricksdemo${random_string.naming.result}"
  tags = {
    Environment = "ywDemo"
    Owner       = lookup(data.external.me.result, "name")
  }
}

resource "azurerm_resource_group" "this" {
  name     = "${local.prefix}-rg"
  location = var.region
  tags     = local.tags
}

resource "azurerm_databricks_workspace" "this" {
  name                        = "${local.prefix}-workspace"
  resource_group_name         = azurerm_resource_group.this.name
  location                    = azurerm_resource_group.this.location
  sku                         = "premium"
  managed_resource_group_name = "${local.prefix}-workspace-rg"
  tags                        = local.tags
}

output "databricks_host" {
  value = "https://${azurerm_databricks_workspace.this.workspace_url}/"
}
