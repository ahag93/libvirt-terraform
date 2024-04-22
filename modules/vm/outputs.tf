# modules/vm/outputs.tf
output "vm_ips" {
  value = [for vm in libvirt_domain.vm : vm.network_interface[0].addresses[0]]
}
