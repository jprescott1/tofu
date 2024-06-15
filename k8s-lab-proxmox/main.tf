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

resource "proxmox_virtual_environment_vm" "control_plane_cloned" {
  count = 1
  name       = "control-plane"
  node_name  = "kube"

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

resource "proxmox_virtual_environment_vm" "worker_node_cloned" {
  count = 3
  name       = "worker-node${count.index}"
  node_name  = "kube"

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