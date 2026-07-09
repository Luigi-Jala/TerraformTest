variable "resource_group_name" {
  type    = string
  default = "quizarena-dev-rg"
}

variable "global_location" {
  type    = string
  default = "centralus"
}

variable "ai_api_key" {
  type      = string
  sensitive = true
}