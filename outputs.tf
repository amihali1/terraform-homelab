# =============================================================================
# Outputs
# =============================================================================

output "vm_ids" {
  description = "VM IDs for all homelab VMs"
  value = {
    docker_nextcloud = proxmox_virtual_environment_vm.docker_nextcloud.vm_id
    homeassistant    = proxmox_virtual_environment_vm.homeassistant.vm_id
    gpu_ai           = proxmox_virtual_environment_vm.gpu_ai.vm_id
  }
}

output "network_map" {
  description = "Homelab network reference"
  value = {
    proxmox_host     = "10.0.0.50:8006"
    docker_nextcloud = "10.0.0.45 — Nextcloud :8080"
    homeassistant    = "10.0.0.46 — HA :8123"
    gpu_ai           = "10.0.0.47 — Ollama :11434, Whisper :10300, Piper :10200, openWakeWord :10400, Open WebUI :3000"
  }
}
