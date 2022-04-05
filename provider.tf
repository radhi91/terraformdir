terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {
    subscription id = "7f1fa9fc-add2-4af6-a5d6-84327a7a4bf8"
    client_id       = "13fdbf88-fbc8-426a-bc9a-97749d73fa7f"
    tenant_id       = "4424ed4f-e8c4-4f83-89af-68ed20b91310"
    client_secret   = "w9B7Q~-.atTGCas3VF6PlOUeP8KGMlrzyMdhJ"  
  }
}