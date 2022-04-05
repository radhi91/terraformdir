variable "location" {
  type    = string
  default = "West Europe"
}
variable "vmname" {
  type    = string
  description = "provide the vm name"
}
variable "username" {
    description = "enter the username"
    default = "radhika"
}
variable "password" {
    description = "enter the password"
}
variable "node_count"{
  type = number
  description = "enter the number of VM's"
}
variable "puip_node_count"{
  type = number
  description = "enter the number of puip's to create"
}
variable "nic_node_count"{
  type = number
  description = "enter the number of nic's to create"
}
