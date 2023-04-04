variable "tenant_id" {
  description = "The tenant id"
  type        = string
}

variable "subscription_id" {
  description = "The subscription id"
  type        = string
}

variable "client_id" {
  description = "The client id"
  type        = string
}

variable "client_secret" {
  description = "The client secret"
  type        = string
}

variable "platform_url" {
  description = "The platform url"
  type        = string
  default     = ""
}

variable "identifier_uri" {
  description = "The platform identifier uri"
  type        = string
  default     = ""
}

variable "stage" {
  description = "The platform stage"
  type        = string
  validation {
    condition = contains([
      "OnBoarding",
      "Dev",
      "QA",
      "IA",
      "EA",
      "Demo",
      "Prod"
    ], var.stage)
    error_message = "Stage must be either: OnBoarding, Dev, QA, IA, EA, Demo, Prod."
  }
}

variable "customer" {
  description = "The customer name"
  type        = string
}

variable "project" {
  description = "The project name"
  type        = string
  default     = ""
}

variable "owner_list" {
  description = "List of mail addresses for App Registration owners"
  type        = list(string)
}

variable "audience" {
  description = "The App Registration audience type"
  type        = string
  validation {
    condition = contains([
      "AzureADMyOrg",
      "AzureADMultipleOrgs"
    ], var.audience)
    error_message = "Only AzureADMyOrg and AzureADMultipleOrgs are supported for audience."
  }
  default = "AzureADMultipleOrgs"
}

variable "webapp_url" {
  description = "The Web Application URL"
  type        = string
}

variable "create_restish" {
  description = "Create the Azure Active Directory Application for Restish"
  type        = bool
  default     = true
}

variable "create_powerbi" {
  description = "Create the Azure Active Directory Application for PowerBI"
  type        = bool
  default     = true
}

variable "location" {
  description = "The Azure location"
  default     = "West Europe"
}

variable "resource_group" {
  description = "Resource group to create which will contain created Azure resources"
  type        = string
}

variable "create_publicip" {
  description = "Create the public IP for the platform"
  type        = bool
  default     = true
}

variable "create_dnsrecord" {
  description = "Create the DNS record"
  type        = bool
  default     = true
}

variable "dns_zone_name" {
  description = "The DNS zone name to create platform subdomain. Example: api.cosmotech.com"
  type        = string
}

variable "dns_zone_rg" {
  description = "The DNS zone resource group"
  type        = string
}

variable "dns_record" {
  description = "The DNS zone name to create platform subdomain. Example: myplatform"
  type        = string
}

variable "create_vnet" {
  description = "Create the Virtual Network for AKS"
  type        = bool
  default     = true
}

variable "vnet_iprange" {
  description = "The Virtual Network IP range. Minimum /26 NetMaskLength"
  type        = string
}

variable "api_version_path" {
  description = "The API version path"
  type        = string
  default     = "/"
}

variable "user_app_role" {
  type = list(object({
    description  = string
    display_name = string
    id           = string
    role_value   = string
  }))
  description = "App role for azuread_application"
}

variable "azuread_service_principal_tags" {
  type        = list(string)
  description = "Common tags for AZ AD service principal"
  default     = [""]
}

variable "azuread_application_tags" {
  type        = list(string)
  description = "Common tags for AZ AD application"
  default     = [""]
}

variable "common_tags" {
  type        = list(string)
  description = "Common tags"
  default     = ["HideApp", "WindowsAzureActiveDirectoryIntegratedApp", "terraformed"]
}