resource "azurerm_resource_group" "backend_rg" {
  name     = "quizarena-backend-rg"
  location = var.global_location
}

module "quizzarena_backend_key_vault" {
  source = "./modules/backend_key_vault"

  resource_group_name = azurerm_resource_group.backend_rg.name
  location            = azurerm_resource_group.backend_rg.location
  vault_name          = "quizarena-backend-kv"
  ai_api_key          = var.ai_api_key
}