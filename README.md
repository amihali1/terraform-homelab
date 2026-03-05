# Homelab Terraform Configuration

Infrastructure as Code for a Proxmox-based homelab running Home Assistant, Nextcloud, and a GPU-accelerated AI stack.

## Architecture

```
Proxmox VE 9.1 (10.0.0.50)
├── docker-nextcloud (VM 100 — 10.0.0.45)
│   ├── Docker
│   └── Nextcloud (:8080)
├── homeassistant (VM 101 — 10.0.0.46)
│   ├── Home Assistant OS (:8123)
│   ├── Govee2MQTT + Mosquitto
│   ├── Dreo (HACS)
│   └── Voice Pipeline (Ollama + Wyoming)
└── gpu-ai (VM 102 — 10.0.0.47)
    ├── RTX 2070 Super (VFIO passthrough)
    ├── Ollama + Qwen 3.5 9B (:11434)
    ├── Whisper STT (:10300)
    ├── Piper TTS (:10200)
    ├── openWakeWord (:10400)
    └── Open WebUI (:3000)
```

## Hardware

| Component    | Spec                          |
|--------------|-------------------------------|
| CPU          | AMD Ryzen 7 2700              |
| GPU          | NVIDIA RTX 2070 Super (8GB)   |
| RAM          | 32 GB DDR4                    |
| Storage      | 500 GB SSD + 4 TB HDD        |
| Motherboard  | Asus TUF B450-Pro Gaming      |

## Prerequisites

1. **Proxmox VE 9.1** installed and accessible at `https://10.0.0.50:8006`
2. **GPU passthrough configured** on the Proxmox host (see `host_config_reference.tf`)
3. **ISO/images uploaded** to Proxmox storage:
   - `ubuntu-24.04.1-live-server-amd64.iso`
   - `haos_ova-14.2.qcow2`
4. **Terraform >= 1.5** installed on your workstation
5. **API token** created in Proxmox (Datacenter → Permissions → API Tokens)

## Quick Start

```bash
# 1. Clone this directory to your workstation
# 2. Set credentials
export PROXMOX_VE_API_TOKEN="terraform@pam!terraform=your-token-uuid"

# Or use username/password
export PROXMOX_VE_USERNAME="root@pam"
export PROXMOX_VE_PASSWORD="your-password"

# 3. Update terraform.tfvars with your values
#    - SSH public key
#    - Storage pool names
#    - ISO filenames

# 4. Initialize and apply
terraform init
terraform plan
terraform apply
```

## Post-Provisioning (manual or Ansible)

Terraform creates the VMs but does NOT configure the operating systems.
After `terraform apply`, you still need to:

### docker-nextcloud (10.0.0.45)
- Install Ubuntu Server via console
- Install Docker: `apt install docker.io`
- Deploy Nextcloud containers

### homeassistant (10.0.0.46)
- Import HAOS qcow2 disk image
- Configure static IP in HAOS
- Install integrations: Govee2MQTT, Dreo, Ollama, Wyoming

### gpu-ai (10.0.0.47)
- Install Ubuntu Server via console
- Install NVIDIA drivers: `apt install nvidia-driver-590`
- Install Docker + NVIDIA Container Toolkit
- Deploy AI stack: `cd ~/ai-stack && docker compose up -d`
- Pull model: `docker exec ollama ollama pull qwen3.5:9b`

See `reference_docker_compose.yml` for the full AI stack compose file.

## File Structure

```
terraform-homelab/
├── versions.tf                    # Terraform & provider versions
├── provider.tf                    # Proxmox provider config
├── variables.tf                   # Input variable definitions
├── terraform.tfvars               # Your environment values
├── vm_docker_nextcloud.tf         # VM 100 — Docker/Nextcloud
├── vm_homeassistant.tf            # VM 101 — Home Assistant OS
├── vm_gpu_ai.tf                   # VM 102 — GPU AI workstation
├── outputs.tf                     # Output values
├── host_config_reference.tf       # Proxmox host VFIO setup reference
└── reference_docker_compose.yml   # AI stack Docker Compose
```

## Notes

- The `host_config_reference.tf` file contains comments only — VFIO/IOMMU
  configuration must be done manually on the Proxmox host before Terraform runs.
- Static IPs are assigned during OS installation, not by Terraform. Consider
  setting up DHCP reservations on your router for consistency.
- For full automation of OS-level configuration, pair this with Ansible playbooks.
