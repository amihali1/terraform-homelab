# =============================================================================
# Proxmox Provider Configuration
# =============================================================================
# Authentication: Use environment variables for credentials
#   export PROXMOX_VE_USERNAME="root@pam"
#   export PROXMOX_VE_PASSWORD="your-password"
#
# Or use an API token (recommended):
#   export PROXMOX_VE_API_TOKEN="terraform@pam!terraform=your-token-uuid"
# =============================================================================

provider "proxmox" {
  endpoint = var.proxmox_endpoint
  insecure = true # Set to false if using valid SSL certs

  ssh {
    agent = true
  }
}
