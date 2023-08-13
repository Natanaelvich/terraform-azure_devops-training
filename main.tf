# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.27.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "myTFResourceGroup"
  location = "Brazil South"
} 

# Create a service plan
resource "azurerm_service_plan" "asp" {
  name                = "myTFAppServicePlan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type            = "Linux"
  sku_name           = "F1"
}

# Create a app service
resource "azurerm_linux_web_app" "app" {
  name                = "myTFTrainingAppService"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    always_on = false
    application_stack {
        docker_image = var.docker_image
        docker_image_tag = var.docker_image_tag
    }
  }
}

variable "docker_image" {
  type = string
  default = "nginx"
}

variable "docker_image_tag" {
  type = string
  default = "latest"
}

output "app_url" {
  value = azurerm_linux_web_app.app.default_hostname
}