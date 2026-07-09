resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "backend_rg" {
  name     = var.resource_group_name
  location = var.global_location
}

module "quizzarena_backend_key_vault" {
  source = "./modules/backend_key_vault"

  resource_group_name = azurerm_resource_group.backend_rg.name
  location            = azurerm_resource_group.backend_rg.location
  
  vault_name          = "quiz-${var.environment}-kv-${random_string.suffix.result}"
  ai_api_key          = var.ai_api_key
}