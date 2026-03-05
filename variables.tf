# =============================================================================
# Global Variables
# =============================================================================

variable "proxmox_endpoint" {
  description = "Proxmox VE API endpoint URL"
  type        = string
  default     = "https://10.0.0.50:8006"
}

variable "proxmox_node" {
  description = "Proxmox node name"
  type        = string
  default     = "pve"
}

variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = ""
}

variable "default_gateway" {
  description = "Default network gateway"
  type        = string
  default     = "10.0.0.1"
}

variable "dns_servers" {
  description = "DNS server list"
  type        = list(string)
  default     = ["10.0.0.1", "1.1.1.1"]
}

variable "default_bridge" {
  description = "Default network bridge on Proxmox"
  type        = string
  default     = "vmbr0"
}

variable "iso_storage" {
  description = "Storage pool for ISO images"
  type        = string
  default     = "local"
}

variable "disk_storage" {
  description = "Storage pool for VM disks"
  type        = string
  default     = "local-lvm"
}

variable "ubuntu_iso" {
  description = "Ubuntu Server ISO filename (must be uploaded to Proxmox)"
  type        = string
  default     = "ubuntu-24.04.1-live-server-amd64.iso"
}

variable "haos_iso" {
  description = "Home Assistant OS disk image filename (must be uploaded to Proxmox)"
  type        = string
  default     = "haos_ova-14.2.qcow2"
}
