variable "location" {
  type    = string
  default = "East US"
}
variable "rgname"{
    type = string
    default = "appservicerg"
}
variable "serviceplan"{
   type = string
   default = "simple-plan"
}
variable "service"{
   type = string
   default = "simple-appservice"
}
variable "mssqlname"{
   type = string
   default = "simple-sql"
}
variable "username" {
    type = string
    default ="radhika"
}
variable "password" {
    type = string
    default = "Radhilatha@9"
}