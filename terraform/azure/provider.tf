terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.77.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "nader-pre-gs"
    storage_account_name = "naderpregs"
    container_name       = "load"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
  skip_provider_registration = true
  use_msi                    = true
  alias                      = "cloud"
}