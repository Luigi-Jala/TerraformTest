data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "backend_kv" {
  name                        = var.vault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  # Elegimos el plan estándar (el más barato/gratuito con créditos)
  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover"
    ]
  }
}

resource "azurerm_key_vault_secret" "ai_api_key" {
  name         = "AiSettings--ApiKey"
  value        = var.ai_api_key
  key_vault_id = azurerm_key_vault.backend_kv.id
}