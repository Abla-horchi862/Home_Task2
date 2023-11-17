provider "azurerm" {
  features = {}
}

# Define variables
variable "resource_group_name" {
  default = "my_rg"
}

variable "location" {
  default = "EAST US"
}

variable "adf_name" {
  default = "my_adf"
}

variable "synapse_name" {
  default = "my_synapse"
}

variable "data_lake_name" {
  default = "my_datalake"
}

variable "databricks_name" {
  default = "my_databricks"
}
variable "databricks_workspace_name" {
  default = "my_workspace"
}

variable "databricks_resource_group" {
  default = "DATABRICKS_rg"
}
variable "vnet_name" {
  default = "my_VNET"
}

variable "subnet_name" {
  default = "my_SUBNET"
}

variable "sql_server_name" {
  default = "my_SQL_SERVER"
}

variable "local_network_gateway_name" {
  default = "my_LOCAL_NETWORK_GATEWAY"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]  
  location            = var.location
}

# Create a subnet
resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]  
}

# Create a local network gateway for on-premises SQL Server
resource "azurerm_local_network_gateway" "local" {
  name                = var.local_network_gateway_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  gateway_ip_address  = "10.1.0.0/24"
  local_network_gateway_address_space = ["196.64.0.0/16"]
}

# Create a virtual network gateway
resource "azurerm_virtual_network_gateway" "gateway" {
  name                = "vpn-gateway"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  vnet_gateway {
    enabled            = true
    vpn_type           = "RouteBased"
    sku                = "VpnGw1"  
    public_ip_address  = azurerm_public_ip.gateway_ip.id
  }
  ip_configuration {
    name                 = "vpn-ip-configuration"
    subnet_id            = azurerm_subnet.subnet.id
    public_ip_address_id = azurerm_public_ip.gateway_ip.id
  }
}

# Create a public IP for the virtual network gateway
resource "azurerm_public_ip" "gateway_ip" {
  name                = "vpn-gateway-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Dynamic"
}


# Output the VPN gateway public IP address
output "vpn_gateway_public_ip" {
  value = azurerm_public_ip.gateway_ip.ip_address
}
# Create Azure Data Factory
resource "azurerm_data_factory" "adf" {
  name                = var.adf_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

# Create Azure Synapse Workspace
resource "azurerm_synapse_workspace" "synapse" {
  name                = var.synapse_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
}

# Define linked service JSON for Azure Synapse Analytics
variable "synapse_linked_service_json" {
  default = <<JSON
    {
      "name": "SynapseLinkedService",
      "properties": {
        "type": "AzureSqlDW",
        "typeProperties": {
          "connectionString": {
            "type": "AzureKeyVaultSecret",
            "store": {
              "referenceName": "my_AKV_REFERENCE",
              "type": "LinkedServiceReference"
            },
            "secretName": "my_AKV_SECRET"
          }
        }
      }
    }
JSON
}

# Create an Azure AD service principal
resource "azuread_application" "sp" {
  name                       = "my_AD"
  homepage                   = "http://localhost"
  available_to_other_tenants = false
}

resource "azuread_service_principal" "sp" {
  application_id = azuread_application.sp.application_id
}

resource "azuread_service_principal_password" "sp_password" {
  service_principal_id = azuread_service_principal.sp.id
  value                = "mysecretpassword"
  end_date             = "2099-01-01T00:00:00Z"
}

# Assign necessary roles to the service principal
resource "azurerm_role_assignment" "role_assignment" {
  principal_id         = azuread_service_principal.sp.id
  role_definition_name = "Synapse Administrator"  
  scope                = azurerm_synapse_workspace.synapse.id
}

# Output the service principal details
output "service_principal_id" {
  value = azuread_service_principal.sp.id
}

output "service_principal_secret" {
  value = azuread_service_principal_password.sp_password.value
}
# Create linked service in ADF for Azure Synapse Analytics
resource "azurerm_data_factory_linked_service" "synapse_linked_service" {
  name                = "SynapseLinkedService"
  resource_group_name = azurerm_resource_group.rg.name
  data_factory_name   = azurerm_data_factory.adf.name

  linked_service_name = "SynapseLinkedService"
  linked_service_json = var.synapse_linked_service_json
}

# Output the Synapse Analytics linked service ID
output "synapse_linked_service_id" {
  value = azurerm_data_factory_linked_service.synapse_linked_service.id
}


# Create Azure Data Lake Storage Gen1
resource "azurerm_storage_account" "datalake" {
  name                     = var.data_lake_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "datalake_container" {
  name                  = "my_datalake"
  storage_account_name = azurerm_storage_account.datalake.name
}

# Output Data Lake Storage account endpoint

output "data_lake_storage_endpoint" {
  value = azurerm_storage_account.datalake.primary_blob_endpoint
}

# Create Azure Databricks
resource "azurerm_databricks_workspace" "databricks" {
  name                    = var.databricks_name
  resource_group_name     = azurerm_resource_group.rg.name
  location                = var.location
  sku                     = "standard"  
}

# Get the Databricks workspace URL
data "azurerm_databricks_workspace" "existing" {
  name                = var.databricks_workspace_name
  resource_group_name = var.databricks_resource_group
}

# Assign a managed identity to the Databricks workspace
resource "azurerm_databricks_workspace_managed_identity" "managed_identity" {
  resource_group_name = var.databricks_resource_group
  workspace_name      = var.databricks_workspace_name
}

# Assign necessary roles to the managed identity
resource "azurerm_role_assignment" "role_assignment" {
  principal_id         = azurerm_databricks_workspace_managed_identity.managed_identity.principal_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = azurerm_storage_account.datalake.id
}

# Output the Databricks workspace URL
output "databricks_workspace_url" {
  value = data.azurerm_databricks_workspace.existing.workspace_url
}
