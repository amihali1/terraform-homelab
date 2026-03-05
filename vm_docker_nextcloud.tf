# =============================================================================
# VM: Docker / Nextcloud Host
# Ubuntu Server 24.04 — 10.0.0.45
# =============================================================================
# Services: Docker, Nextcloud (port 8080)
# Future: Portfolio website
# =============================================================================

resource "proxmox_virtual_environment_vm" "docker_nextcloud" {
  name        = "docker-nextcloud"
  description = "Ubuntu Server - Docker & Nextcloud host"
  node_name   = var.proxmox_node
  vm_id       = 100

  tags = ["ubuntu", "docker", "nextcloud"]

  # ---- Hardware ----
  cpu {
    cores   = 2
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 4096 # 4 GB
  }

  # ---- BIOS / Machine ----
  bios       = "seabios"
  machine    = "q35"

  # ---- Boot Disk ----
  disk {
    datastore_id = var.disk_storage
    interface    = "scsi0"
    size         = 100 # GB
    file_format  = "raw"
  }

  # ---- Data Disk (4TB HDD) ----
  # Uncomment if the 4TB drive is passed through or mounted as a separate storage pool
  # disk {
  #   datastore_id = "hdd-storage"
  #   interface    = "scsi1"
  #   size         = 4000
  #   file_format  = "raw"
  # }

  # ---- Network ----
  network_device {
    bridge  = var.default_bridge
    model   = "virtio"
  }

  # ---- OS Image ----
  cdrom {
    file_id = "${var.iso_storage}:iso/${var.ubuntu_iso}"
  }

  # ---- Cloud-Init (if using cloud image instead of ISO) ----
  # initialization {
  #   ip_config {
  #     ipv4 {
  #       address = "10.0.0.45/24"
  #       gateway = var.default_gateway
  #     }
  #   }
  #   dns {
  #     servers = var.dns_servers
  #   }
  #   user_account {
  #     keys     = [var.ssh_public_key]
  #     username = "user"
  #   }
  # }

  operating_system {
    type = "l26" # Linux 2.6+ kernel
  }

  agent {
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      cdrom, # Don't force ISO re-attach after initial install
    ]
  }
}
