variable "resource_group_name" {
  type        = string
  description = "Resource group name where the key vault will be created"
}

variable "location" {
  type        = string
  description = "Azure location where the key vault will be created"
}

variable "vault_name" {
  type        = string
  description = "Unique global name for the Key Vault"
}

variable "ai_api_key" {
  type        = string
  description = "The AI API Key that we will save as a secret"
  sensitive   = true
}