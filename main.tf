# Getting existing Keyvault name to store credentials as secrets
data "azurerm_key_vault" "key_vault" {
  name  = var.keyvault_name
  resource_group_name = var.resource_group_name
}


# Creates a Virtual machine
resource "azurerm_virtual_machine" "virtual_machine" {
  name                             = var.name
  location                         = var.location
  resource_group_name              = var.resource_group_name
  network_interface_ids            = [azurerm_network_interface.network_interface.id]
  vm_size                          = var.vm_size
  
  delete_os_disk_on_termination    = var.delete_os_disk_on_termination
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer
    sku       = var.sku
    version   = var.storage_image_version
  }

  storage_os_disk {
    name              = "${var.name}-disk"
    caching           = var.caching
    create_option     = var.create_option
    managed_disk_type = var.managed_disk_type
    os_type           = var.os_type
    disk_size_gb = var.disk_size_gb
  }

  os_profile {
    computer_name  = var.name
    admin_username = var.admin_username
    admin_password = random_password.password1.result
  }

  dynamic "os_profile_linux_config" {
    for_each = var.os_type == "Linux" ? [1] : []
    content {
      disable_password_authentication = var.disable_password_authentication
    }
  }

  dynamic "os_profile_windows_config" {
    for_each = var.os_type == "Windows" ? [1] : []
    content {
      timezone = var.timezone
      provision_vm_agent = var.provision_vm_agent
    }
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
  depends_on = [
    azurerm_network_interface.network_interface
  ]
}

# Creates a private IP network interface card
resource "azurerm_network_interface" "network_interface" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_configuration {
    name                          = "${var.name}-ip"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
  }
}

# Creates a MSSQL Virtual machine Image
resource "azurerm_mssql_virtual_machine" "mssql_virtual_machine" {
  virtual_machine_id               = azurerm_virtual_machine.virtual_machine.id
  sql_license_type                 = var.sql_license_type
  r_services_enabled               = var.r_services_enabled
  sql_connectivity_port            = var.sql_connectivity_port
  sql_connectivity_type            = var.sql_connectivity_type
  sql_connectivity_update_password = random_password.password1.result
  sql_connectivity_update_username = var.sql_connectivity_update_username
}

# Creates a random password for SQL VM
resource "random_password" "password1" {
    length = 12
    lower = true
    min_lower = 6
    min_numeric= 2
    min_special= 2
    min_upper= 2
    numeric = true
    special = true
    upper = true
    

}

# Creates a secret to store DB credentials 
resource "azurerm_key_vault_secret" "sqlvm_password" {
    name =  "${var.name}-sqlpwd"
    value = random_password.password1.result
    key_vault_id = data.azurerm_key_vault.key_vault.id
    
    depends_on = [ azurerm_mssql_virtual_machine.mssql_virtual_machine]
}

# Creates Network Security Group NSG for Virtual Machine
resource "azurerm_network_security_group" "nsg" {
  name                = "${var.name}-nsg"
  location            = azurerm_windows_virtual_machine.example.location
  resource_group_name = azurerm_windows_virtual_machine.example.resource_group_name
}


# Creates Network Security Group Default Rules for Virtual Machine
resource "azurerm_network_security_rule" "nsg_rules" {
  for_each                    = var.nsg_rules
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_address_prefix       = each.value.source_address_prefix
  source_port_range           = each.value.source_port_range
  destination_address_prefix  = each.value.destination_address_prefix
  destination_port_range      = each.value.destination_port_range
  network_security_group_name = azurerm_network_security_group.nsg.name
  resource_group_name         = azurerm_windows_virtual_machine.example.resource_group_name
}


# Creates association (i.e) adds NSG to the NIC
resource "azurerm_network_interface_security_group_association" "security_group_association" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
