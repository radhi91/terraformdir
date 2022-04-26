output "stname" {
  value       = azurerm_storage_account.examplestorage.name
  description = "The storage account name is."
}

output "blob" {
  description = "Blob name is"
  value       = azurerm_storage_container.Blob.name
}
output "Queue" {
  description = "IPs of all VM's provisoned."
  value       = azurerm_storage_queue.Queue.name
}
