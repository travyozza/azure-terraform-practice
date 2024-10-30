variable "subscription_id" {
  description = "My Azure subscription ID"
}

variable "location" {
  description = "The Azure region to deploy resources"
  default     = "AustraliaEast"
}

variable "prefix" {
  description = "A prefix to add to all resources"
  default     = "atp-"
}
