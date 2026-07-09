variable "environment" {
  type        = string
  description = "El entorno actual (dev, prod, etc.)"
  default     = "dev"
}

variable "resource_group_name" {
  type    = string
  default = "quiz-app-dev-rg"
}

variable "global_location" {
  type    = string
  default = "centralus"
}

variable "ai_api_key" {
  type      = string
  sensitive = true
}