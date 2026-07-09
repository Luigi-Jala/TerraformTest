output "key_vault_uri" {
  value       = azurerm_key_vault.backend_kv.vault_uri
  description = "This URL is mean to be used on backend to fetch secrets."
}