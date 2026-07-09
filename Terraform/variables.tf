variable "global_location" {
  type    = string
  default = "centralus"
}

variable "ai_api_key" {
  type      = string
  sensitive = true
}