output "vmname" {
  value       = azurerm_windows_virtual_machine.terrargvm.*.name
  description = "The VM's provisioned are."
}

output "PublicIP" {
  description = "IPs of all VM's provisoned."
  value       = azurerm_public_ip.terrargpuip.*.ip_address
}
output "PrivateIP" {
  description = "IPs of all VM's provisoned."
  value       = azurerm_network_interface.terrargnic.*.private_ip_address
}
