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

resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "kube"

  source_file {
    path = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm_cloned" {
  name       = "ubuntu-test"
  node_name  = "kube"
  vm_id      = 1000

  clone {
    vm_id = 100
  }

  cpu {
    cores = 2
  }
  memory {
    dedicated = 8000
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