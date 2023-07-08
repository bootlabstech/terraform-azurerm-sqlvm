# VM
variable "keyvault_name" {
     type = string
     description = "keyvault name to store the sql password"

}
variable "name" {
     type = string
     description = "Specifies the name of the Virtual Machine. Changing this forces a new resource to be created."
}
variable "location" {
     type = string
     description = "Specifies the Azure Region where the Virtual Machine exists. Changing this forces a new resource to be created."
}
variable "resource_group_name" {
     type = string
     description = " Specifies the name of the Resource Group in which the Virtual Machine should exist."
}
variable "vm_size" {
     type = string
     description = " Specifies the size of the Virtual Machine."
}
variable "delete_os_disk_on_termination" {
  type        = bool
  description = " Should the OS Disk (either the Managed Disk / VHD Blob) be deleted when the Virtual Machine is destroyed? Defaults to false."
  default     = true
}

variable "delete_data_disks_on_termination" {
  type        = bool
  description = "Should the Data Disks (either the Managed Disks / VHD Blobs) be deleted when the Virtual Machine is destroyed? Defaults to false."
  default     = true
}
variable "publisher" {
     type = string
     description = "Specifies the publisher of the image used to create the virtual machine"
     default = "MicrosoftSQLServer"
}

variable "sku" {
     type = string
     description = "Specifies the SKU of the image used to create the virtual machine."
     default = "Standard"
}

variable "offer" {
     type = string
     description = "Specifies the offer of the image used to create the virtual machine"
}

variable "storage_image_version" {
  type        = string
  description = "Specifies the version of the image used to create the virtual machine. Changing this forces a new resource to be created."
  default     = "latest"
}
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
variable "os_type" {
     type = string
     description = "Specifies the Operating System on the OS Disk. Possible values are Linux and Windows."
}
variable "managed_disk_type" {
     type = string
     description = " Specifies the type of managed disk to create. Possible values are either Standard_LRS, StandardSSD_LRS, Premium_LRS or UltraSSD_LRS."
}
variable "disk_size_gb" {
     type = number
     description = " Specifies the size of the data disk in gigabytes."
}
variable "admin_username" {
     type = string
     description = "Specifies the name of the local administrator account."
}
variable "disable_password_authentication" {
     type = string
     description = "Specifies whether password authentication should be disabled. If set to false, an admin_password must be specified."
     default = "true"
}
variable "provision_vm_agent" { 
     type = bool
     description = "Should the Azure Virtual Machine Guest Agent be installed on this Virtual Machine? Defaults to false."
     default = true
}
variable "subnet_id" {
     type = string
     description = "The ID of the Subnet where this Network Interface should be located in."
}
variable "private_ip_address_allocation" {
     type = string
     description = "The allocation method used for the Private IP Address. Possible values are Dynamic and Static"
     default = "Dynamic"
}


variable "timezone" {
     type = string
     description = " Specifies the time zone of the virtual machine"
     default = ""
}
# MSSQL VM Image
variable "sql_connectivity_update_username" {
     type = string
     description = "The SQL Server sysadmin login to create."
}

variable "sql_license_type" {
     type = string
     description = "The SQL Server license type. Possible values are AHUB (Azure Hybrid Benefit), DR (Disaster Recovery), and PAYG (Pay-As-You-Go)."
     default = "PAYG"

}
variable "r_services_enabled" { 
     type = bool
     description = "Should R Services be enabled?"
     default = true
}
variable "sql_connectivity_port" {
     type = number
     description = "The SQL Server license type. Possible values are AHUB (Azure Hybrid Benefit), DR (Disaster Recovery), and PAYG (Pay-As-You-Go)."
     default = 1433

}
variable "sql_connectivity_type" {
     type = string
     description = "The SQL Server license type. Possible values are AHUB (Azure Hybrid Benefit), DR (Disaster Recovery), and PAYG (Pay-As-You-Go)."
     default = "PRIVATE"

}