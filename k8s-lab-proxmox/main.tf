terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.58.1"
    }
  }
}

provider "proxmox" {
  endpoint = PROX_ENDPOINT
  insecure = true

  ssh {
    agent    = true
    username = "root"
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm" {
  name      = "test-ubuntu"
  node_name = "kube"
  vm_id     = 1000

  agent {
    enabled = true
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 8000
  }

  efi_disk {
    datastore_id = "local-lvm"
    file_format  = "raw"
    type         = "4m"
  }

  disk {
    datastore_id = "local-lvm"
    file_id      = proxmox_virtual_environment_file.ubuntu_cloud_image.id
    interface    = "virtio0"
    iothread     = true
    discard      = "on"
    size         = 40
  }

  network_device {
    bridge = "vmbr0"
  }

  started = false
}

resource "proxmox_virtual_environment_file" "ubuntu_cloud_image" {
  content_type = "iso"
  datastore_id = "local"
  node_name    = "kube"

  source_file {
    path = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
  }
}

data "local_file" "ssh_public_key" {
  filename = "./id_rsa.pub"
}

resource "proxmox_virtual_environment_file" "cloud_config" {
  content_type = "snippets"
  datastore_id = "snips"
  node_name    = "kube"

  source_raw {
    data = <<EOF
#cloud-config
runcmd:
    - apt update
    # - apt install -y qemu-guest-agent net-tools
    # - timedatectl set-timezone America/Toronto
    # - systemctl enable qemu-guest-agent
    # - systemctl start qemu-guest-agent
    # - echo "done" > /tmp/vendor-cloud-init-done
    EOF

    file_name = "cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "ubuntu_vm_cloned" {
  depends_on = [proxmox_virtual_environment_vm.ubuntu_vm]
  name       = "ubuntu-2204-clone"
  node_name  = "kube"
  vm_id      = 100

  clone {
    vm_id = 100
  }

  initialization {
    #    interface = "scsi0"
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "ubuntu"
      keys     = [trimspace(data.local_file.ssh_public_key.content)]
    }

  
  }

  started = true
}