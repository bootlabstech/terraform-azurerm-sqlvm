# VM
variable "name" {
  type        = string
  description = "Specifies the name of the Virtual Machine. No uppercase and less than 15 characters"
}
variable "location" {
  type        = string
  description = "Specifies the Azure Region where the Virtual Machine exists. Must be one of the following Central India or South India."
}
variable "resource_group_name" {
  type        = string
  description = " Specifies the name of the Resource Group in which the Virtual Machine should exist."
}
variable "vm_size" {
  type        = string
  description = "Specifies the size of the Virtual Machine. See also Azure documentation for all options."
}
variable "delete_os_disk_on_termination" {
  type        = bool
  description = "Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed? Defaults to false."
  default     = true
}
variable "delete_data_disks_on_termination" {
  type        = bool
  description = "Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed? Defaults to false."
  default     = false
}

# storage_image_reference
variable "publisher" {
  type        = string
  description = "Specifies the publisher of the image used to create the virtual machine."
  default     = "MicrosoftSQLServer"
}
variable "offer" {
  type        = string
  description = "Specifies the offer of the image used to create the virtual machine."
}
variable "sku" {
  type        = string
  description = "Specifies the SKU of the image used to create the virtual machine."
  default     = "Standard"
}
variable "storage_image_version" {
  type        = string
  description = "Specifies the version of the image used to create the virtual machine."
  default     = "latest"
}

# storage_os_disk
variable "caching" {
  type        = string
  description = "Specifies the caching requirements for the Data Disk. Possible values include None, ReadOnly and ReadWrite."
  default     = "ReadWrite"
}
variable "create_option" {
  type        = string
  description = "Specifies how the data disk should be created. Possible values are Attach, FromImage and Empty."
  default     = "FromImage"
}
variable "managed_disk_type" {
  type        = string
  description = "Specifies the type of managed disk to create. Possible values are either Standard_LRS, StandardSSD_LRS, Premium_LRS or UltraSSD_LRS."
}
variable "os_type" {
  type        = string
  description = "Specifies the Operating System on the OS Disk. Possible values are Linux and Windows."
}
variable "disk_size_gb" {
  type        = number
  description = "Specifies the size of the OS Disk in gigabytes."
}

# os_profile
variable "admin_username" {
  type        = string
  description = "Specifies the name of the local administrator account."

}

variable "disable_password_authentication" {
  type        = bool
  description = "Specifies whether password authentication should be disabled. If set to false, an admin_password must be specified."
  default     = false
}
variable "timezone" {
  type        = string
  description = "Specifies the time zone of the virtual machine, the possible values are defined here. Changing this forces a new resource to be created."
  default     = ""
}
variable "provision_vm_agent" {
  type        = bool
  description = "Should the Azure Virtual Machine Guest Agent be installed on this Virtual Machine? Defaults to false."
  default     = true
}

# network_interface
variable "subnet_id" {
  type        = string
  description = "The ID of the Subnet where this Network Interface should be located in."
}
variable "private_ip_address_allocation" {
  type        = string
  description = "The allocation method used for the Private IP Address. Possible values are Dynamic and Static."
  default     = "Dynamic"
}

# MSSQL VM
variable "sql_license_type" {
  type        = string
  description = "The SQL Server license type. Possible values are AHUB (Azure Hybrid Benefit), DR (Disaster Recovery), and PAYG (Pay-As-You-Go). Changing this forces a new resource to be created."
  default     = "PAYG"

}
variable "r_services_enabled" {
  type        = bool
  description = "Should R Services be enabled?"
  default     = true
}
variable "sql_connectivity_port" {
  type        = number
  description = "The SQL Server port. Defaults to 1433."
  default     = 1433

}
variable "sql_connectivity_type" {
  type        = string
  description = "The connectivity type used for this SQL Server. Possible values are LOCAL, PRIVATE and PUBLIC. Defaults to PRIVATE."
  default     = "PRIVATE"

}
variable "sql_connectivity_update_username" {
  type        = string
  description = "The SQL Server sysadmin login to create."
}

# storage_configuration
variable "data_disk_type" {
  type        = string
  description = "The type of disk configuration to apply to the SQL Server. Valid values include NEW, EXTEND, or ADD."
  default     = "NEW"
}
variable "storage_workload_type" {
  type        = string
  description = "The type of storage workload. Valid values include GENERAL, OLTP, or DW."
  default     = "GENERAL"
}
variable "default_file_path" {
  type        = string
  description = "The SQL Server default path"
  default     = "F:/data"
}

# azurerm_network_security_rule
variable "nsg_rules" {
  type = map(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_address_prefix      = string
    source_port_range          = string
    destination_address_prefix = string
    destination_port_range     = string
  }))
  default = {
    "https" = {
      access                     = "Allow"
      destination_address_prefix = "*"
      destination_port_range     = "*"
      direction                  = "Inbound"
      name                       = "allow-https"
      priority                   = 100
      protocol                   = "Tcp"
      source_address_prefix      = "*"
      source_port_range          = "*"
    }
  }

}

# Datadisk azurerm_managed_disk
variable "datadisk_create_option" {
  type        = string
  description = " The method to use when creating the managed disk. Changing this forces a new resource to be created. Possible values include: Empty,Import,ImportSecure,Copy,FromImage,Restore, Upload"
  default     = "Empty"
}
variable "data_disk_size_gb" {
  type        = number
  description = "Specifies the size of the managed disk to create in gigabytes. If create_option is Copy or FromImage, then the value must be equal to or greater than the source's size. The size can only be increased."
}

# Datadisk attachment
variable "lun" {
  type        = number
  description = "The Logical Unit Number of the Data Disk, which needs to be unique within the Virtual Machine. Changing this forces a new resource to be created."
  default     = 0
}
variable "data_disk_caching" {
  type        = string
  description = "Specifies the caching requirements for this Data Disk. Possible values include None, ReadOnly and ReadWrite."
  default     = "ReadWrite"

}

# azurerm_recovery_services_vault
variable "recovery_services_vault_name" {
  type        = string
  description = "name of the recover service vault"
}
variable "services_vault_resource_group_name" {
  type        = string
  description = "name of resource group where the recovery service vault reside in"
}

# Keyvault
variable "keyvault_name" {
  type        = string
  description = "keyvault name to store the sql password"

}