variable "name" {
     type = string
     description = "Specifies the name of the Virtual Machine. Changing this forces a new resource to be created."
}
variable "publisher" {
     type = string
     description = " Specifies the publisher of the image used to create the virtual machine. Examples: Canonical, MicrosoftWindowsServer"
}

variable "admin_username" {
     type = string
     description = "Specifies the name of the local administrator account."
}
variable "disk_size_gb" {
     type = number
     description = "Specifies custom data to supply to the machine. On Linux-based systems, this can be used as a cloud-init script."
}
variable "private_ip_address_allocation" {
     type = string
     description = "The allocation method used for the Private IP Address. Possible values are Dynamic and Static"
     default = "Dynamic"
}
variable "resource_group_name" {
     type = string
     description = "name of the resource group"
}
variable "sku" {
     type = string
     description = "Specifies the SKU of the image used to create the virtual machine. Examples: 18.04-LTS, 2019-Datacenter"
}
variable "location" {
     type = string
     description = "location of the resource group"
}
variable "offer" {
     type = string
     description = "Specifies the offer of the image used to create the virtual machine. Examples: UbuntuServer, WindowsServer"
}
variable "os_type" {
     type = string
     description = "Specifies the Operating System on the OS Disk. Possible values are Linux and Windows."
}
variable "subnet_id" {
     type = string
     description = "The ID of the Subnet where this Network Interface should be located in."
}
variable "vm_size" {
     type = string
     description = "Specifies the size of the Virtual Machine. See also Azure VM Naming Conventions."
}
variable "managed_disk_type" {
     type = string
     description = "Specifies the type of managed disk to create. Possible values are either Standard_LRS, StandardSSD_LRS, Premium_LRS or UltraSSD_LRS."
}
# variable "admin_password" {
#      type = string
#      description = "The password associated with the local administrator account."
# }

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

variable "timezone" {
     type = string
     description = "(optional) describe your variable"
     default = ""
}

variable "provision_vm_agent" { 
     type = bool
     description = "(optional) describe your variable"
     default = true
}


variable "disable_password_authentication" {
     type = string
     description = "Name of password"
     default = "true"
}

variable "sql_connectivity_update_username" {
     type = string
     description = "Username of sql"
}
variable "keyvault_name" {
     type = string
     description = "keyvault name"

}
