terraform {
  required_version = ">= 1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "quizarena-ops-rg"
    container_name       = "terraform-state"
    key                  = "production.terraform.tfstate"
    # storage_account_name must be dynamically via command -backend-config="storage_account_name=<storage_account_name>"
  }
}

provider "azurerm" {
  features {}
}