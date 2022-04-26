variable "location" {
  type    = string
  default = "East US"
}
variable "rgname"{
    type = string
    default = "vmwithstoragerg"
}
variable "username" {
    type = string
    default ="radhika"
}
variable "password" {
    type = string
    default = "Radhilatha@9"
}
variable "prefix"{
    type = string
    default = "myip"
    
}
variable "vnet_prefix"{
    type    = string
    default = "10.10.0.0/16"

}
variable "snet_prefix"{
    type    = string
    default = "10.10.1.0/24"
}

