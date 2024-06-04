provider "proxmox" {
  pm_api_url    = "https://kube.tail666eff.ts.net:8006/api2/json"
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}

resource "proxmox_vm_qemu" "test-vm" {
  name        = "ubuntu-test"
  target_node = "kube"
  vmid        = 5002
  clone       = "ubuntu-2204-base"
  full_clone  = true
  boot        = "order=order=scsi0;ide0;net0"
  memory      = 8000
  cores       = 2
  scsihw      = "virtio-scsi-single"
  ssh_user    = "jimmy"
  sshkeys     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAsycFZCGi6778LPkAq2I9RJlmkNrMwEEiZvGwWp5tvg jimmyjorts@gloogleegloo.com"

  disks {
    scsi {
      scsi0 {
        disk {
          size    = "40G"
          storage = "local-lvm"
        }
      }
    }
  }
}