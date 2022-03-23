variable "tenant_id" {
  description = "The tenant id"
}

variable "subscription_id" {
  description = "The subscription id"
}

variable "client_id" {
  description = "The client id"
}

variable "client_secret" {
  description = "The client secret"
}

variable "platform_url" {
  description = "The platform identifier uri"
}

variable "identifier_uri" {
  description = "The platform identifier uri"
}

variable "stage" {
  description = "The platform stage"
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
}

variable "project" {
  description = "The project name"
}

variable "owner_list" {
  description = "List of mail addresses for App Registration owners"
  type = list(string)
  default = []
}

variable "audience" {
  description = "The App Registration audience type"
  validation {
      condition = contains([
        "AzureADMyOrg",
        "AzureADMultipleOrgs"
      ], var.audience)
    error_message = "Only AzureADMyOrg and AzureADMultipleOrgs are supported for audience."
  }
  default = "AzureADMultipleOrgs"
}
