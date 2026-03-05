# =============================================================================
# VM: Home Assistant OS
# 10.0.0.46
# =============================================================================
# Home Assistant Core 2026.2.3, Supervisor 2026.02.3
# Integrations: Govee2MQTT, Dreo (HACS), Ollama, Wyoming (Whisper/Piper/openWakeWord)
# MQTT: Mosquitto broker
# =============================================================================

resource "proxmox_virtual_environment_vm" "homeassistant" {
  name        = "homeassistant"
  description = "Home Assistant OS"
  node_name   = var.proxmox_node
  vm_id       = 101

  tags = ["homeassistant", "smarthome"]

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
  # HAOS requires UEFI with Secure Boot DISABLED
  bios    = "ovmf"
  machine = "q35"

  efi_disk {
    datastore_id      = var.disk_storage
    type              = "4m"
    pre_enrolled_keys = false # Secure Boot disabled
  }

  # ---- Boot Disk ----
  # HAOS is imported from a qcow2 image; adjust size as needed
  disk {
    datastore_id = var.disk_storage
    interface    = "scsi0"
    size         = 32 # GB — HAOS default is 32GB
    file_format  = "raw"
  }

  # ---- Network ----
  network_device {
    bridge  = var.default_bridge
    model   = "virtio"
  }

  # ---- HAOS Image ----
  # Note: HAOS uses a pre-built disk image, not an ISO.
  # You may need to import the qcow2 manually first:
  #   qm importdisk 101 haos_ova-14.2.qcow2 local-lvm
  # Then attach it via the Proxmox UI or adjust this config.

  operating_system {
    type = "l26"
  }

  agent {
    enabled = true
  }

  # ---- USB Passthrough (future Zigbee coordinator) ----
  # Uncomment when you add the SONOFF Zigbee 3.0 USB Dongle Plus
  # usb {
  #   host = "vendor_id:product_id" # e.g., "10c4:ea60" for SONOFF dongle
  #   usb3 = false
  # }

  lifecycle {
    ignore_changes = [
      disk, # HAOS manages its own disk after import
    ]
  }
}
