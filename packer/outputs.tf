output "ssh_connection_string" {
  value = module.servers.ssh_connection_string
}

output "app_ip" {
  value = module.servers.app_public_ip
}
