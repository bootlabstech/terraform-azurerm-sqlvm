data "azurerm_key_vault" "key_vault" {
  name  = var.keyvault_name
  resource_group_name = var.resource_group_name
}

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
    # custom_data    = var.custom_data
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

resource "azurerm_mssql_virtual_machine" "mssql_virtual_machine" {
  virtual_machine_id               = azurerm_virtual_machine.virtual_machine.id
  sql_license_type                 = "PAYG"
  r_services_enabled               = true
  sql_connectivity_port            = 1433
  sql_connectivity_type            = "PRIVATE"
  sql_connectivity_update_password = random_password.password2.result
  sql_connectivity_update_username = var.sql_connectivity_update_username
}

resource "random_password" "password1" {
    length = 8
    lower = true
    min_lower = 1
    min_numeric= 1
    min_special= 1
    min_upper= 1
    numeric = true
    override_special = "_"
    special = true
    upper = true
    

}
resource "random_password" "password2" {
    length = 8
    lower = true
    min_lower = 1
    min_numeric= 1
    min_special= 1
    min_upper= 1
    numeric = true
    override_special = "_"
    special = true
    upper = true
    

}
resource "azurerm_key_vault_secret" "sqlvm_password" {
    name =  "${var.name}-sqlpwd"
    value = random_password.password2.result
    key_vault_id = data.azurerm_key_vault.key_vault.id
    
    depends_on = [ azurerm_mssql_virtual_machine.mssql_virtual_machine]
}