# =============================================================================
# Proxmox Host Configuration (NOT managed by Terraform)
# =============================================================================
# These files must be configured manually on the Proxmox host BEFORE
# running Terraform. They enable IOMMU and VFIO for GPU passthrough.
#
# After making changes: update-initramfs -u -k all && reboot
# =============================================================================

# --- BIOS ---
# Enable IOMMU / AMD-Vi in:
#   Asus TUF B450-Pro Gaming → Advanced → North Bridge → IOMMU = Enabled

# --- /etc/default/grub ---
# GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt"
# Then run: update-grub

# --- /etc/modules-load.d/vfio.conf ---
# vfio
# vfio_iommu_type1
# vfio_pci
# vfio_virqfd

# --- /etc/modprobe.d/vfio.conf ---
# options vfio-pci ids=10de:1e84,10de:10f8,10de:1ad8,10de:1ad9

# --- /etc/modprobe.d/blacklist-nvidia.conf ---
# blacklist nouveau
# blacklist nvidia
# blacklist nvidiafb
# blacklist nvidia_drm
# blacklist snd_hda_intel
# blacklist xhci_hcd
# blacklist i2c_nvidia_gpu
# softdep nouveau pre: vfio-pci
# softdep snd_hda_intel pre: vfio-pci
# softdep xhci_pci pre: vfio-pci

# --- Verification commands ---
# dmesg | grep -i iommu          # Confirm IOMMU is active
# lspci -nnk -s 08:00            # Confirm vfio-pci is bound to all GPU functions
