resource "proxmox_vm_qemu" "test-vm" {
  name        = "test-vm"
  target_node = "kube"
  vmid        = 2000
  clone       = "ubuntu-2204-template"
  full_clone  = true
  memory      = 8000
  cores       = 2
  ssh_user    = "jimmy"
  sshkeys     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsycFZCGi6778LPkAq2I9RJlmkNrMwEEiZvGwWp5tvg jimmyjorts@gloogleegloo.com"
}