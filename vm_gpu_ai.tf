# =============================================================================
# VM: GPU AI Workstation
# Ubuntu Server 24.04 — 10.0.0.47
# =============================================================================
# GPU: RTX 2070 Super (PCI 08:00) passthrough via VFIO
# Services: Ollama (:11434), Whisper (:10300), Piper (:10200),
#           openWakeWord (:10400), Open WebUI (:3000)
# Future: Stock sentiment analysis pipeline
# =============================================================================

resource "proxmox_virtual_environment_vm" "gpu_ai" {
  name        = "gpu-ai"
  description = "Ubuntu Server - GPU passthrough AI workstation"
  node_name   = var.proxmox_node
  vm_id       = 102

  tags = ["ubuntu", "gpu", "ai", "ollama"]

  # ---- Hardware ----
  cpu {
    cores   = 4
    sockets = 1
    type    = "host"
  }

  memory {
    dedicated = 16384 # 16 GB
  }

  # ---- BIOS / Machine ----
  # GPU passthrough requires UEFI + q35
  bios    = "ovmf"
  machine = "q35"

  efi_disk {
    datastore_id      = var.disk_storage
    type              = "4m"
    pre_enrolled_keys = false
  }

  # ---- Boot Disk ----
  disk {
    datastore_id = var.disk_storage
    interface    = "scsi0"
    size         = 100 # GB
    file_format  = "raw"
  }

  # ---- Network ----
  network_device {
    bridge  = var.default_bridge
    model   = "virtio"
  }

  # ---- OS Image ----
  cdrom {
    file_id = "${var.iso_storage}:iso/${var.ubuntu_iso}"
  }

  # ---- GPU Passthrough: RTX 2070 Super ----
  # PCI 08:00.0 — GeForce RTX 2070 SUPER [10de:1e84]
  # PCI 08:00.1 — HD Audio [10de:10f8]
  # PCI 08:00.2 — USB 3.1 [10de:1ad8]
  # PCI 08:00.3 — USB Type-C [10de:1ad9]
  #
  # All 4 functions are bound to vfio-pci on the Proxmox host.
  # Host config files:
  #   /etc/modules-load.d/vfio.conf
  #   /etc/modprobe.d/vfio.conf        — ids=10de:1e84,10de:10f8,10de:1ad8,10de:1ad9
  #   /etc/modprobe.d/blacklist-nvidia.conf

  hostpci {
    device  = "hostpci0"
    id      = "0000:08:00"
    pcie    = true
    rombar  = true
  }

  operating_system {
    type = "l26"
  }

  agent {
    enabled = true
  }

  lifecycle {
    ignore_changes = [
      cdrom,
    ]
  }
}
