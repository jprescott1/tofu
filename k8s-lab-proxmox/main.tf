terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.58.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.prox_endpoint
  insecure = true

  ssh {
    agent    = true
    username = "runner"
  }
}

resource "proxmox_virtual_environment_vm" "control_plane_cloned" {
  count = length(var.host_name)
  name       = var.host_name[count.index]
  node_name  = "kube"
  vm_id = var.vm_id + count.index

  clone {
    vm_id = 8000
  }

  cpu {
    cores = 2
  }
  memory {
    dedicated = 8200
  }

  initialization {
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }
  }

  started = true
}
