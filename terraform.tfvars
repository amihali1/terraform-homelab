# =============================================================================
# Homelab Terraform Values
# =============================================================================
# Update these values to match your environment.
# For sensitive values, use environment variables instead:
#   export TF_VAR_ssh_public_key="ssh-ed25519 AAAA..."
# =============================================================================

proxmox_endpoint = "https://10.0.0.50:8006"
proxmox_node     = "pve"
default_gateway  = "10.0.0.1"
dns_servers      = ["10.0.0.1", "1.1.1.1"]
default_bridge   = "vmbr0"
iso_storage      = "local"
disk_storage     = "local-lvm"
ubuntu_iso       = "ubuntu-24.04.1-live-server-amd64.iso"
haos_iso         = "haos_ova-14.2.qcow2"

# Paste your SSH public key here or set via TF_VAR_ssh_public_key
# ssh_public_key = "ssh-ed25519 AAAA..."
