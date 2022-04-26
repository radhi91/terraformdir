output "vmname" {
  value       = azurerm_linux_virtual_machine.lvm.name
  description = "The VM provisioned is."
}

output "PublicIP" {
  description = "IP of the VM provisoned is."
  value       = azurerm_public_ip.puip.ip_address
}
output "PrivateIP" {
  description = "IPs of all VM's provisoned."
  value       = azurerm_network_interface.nic.private_ip_address
}
output "sname" {
  value = module.storageacc.stname
}

output "bblob" {
  value = module.storageacc.blob
}
output "queue" {
  value = module.storageacc.Queue
}
