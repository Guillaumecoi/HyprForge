#!/usr/bin/env bash
#
# Encrypted Swap Setup Script
# This script encrypts an existing swap partition with a keyfile
# Run this AFTER the initial NixOS installation and first boot
#
# Usage: sudo ./setup-encrypted-swap.sh <swap-partition>
# Example: sudo ./setup-encrypted-swap.sh /dev/nvme0n1p2
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

print_info() {
    echo -e "${CYAN}  → ${NC}${1}"
}

print_success() {
    echo -e "${GREEN}  ✓ ${NC}${1}"
}

print_warning() {
    echo -e "${YELLOW}  ⚠ ${NC}${1}"
}

print_error() {
    echo -e "${RED}  ✗ ${NC}${1}"
}

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    print_error "This script must be run as root"
    echo "Usage: sudo $0 <swap-partition>"
    exit 1
fi

# Check if swap partition is provided
if [[ -z "$1" ]]; then
    print_error "Swap partition not specified"
    echo "Usage: sudo $0 <swap-partition>"
    echo "Example: sudo $0 /dev/nvme0n1p2"
    exit 1
fi

SWAP_PART="$1"

# Validate swap partition exists
if [[ ! -b "$SWAP_PART" ]]; then
    print_error "Partition $SWAP_PART does not exist"
    exit 1
fi

echo -e "${CYAN}"
echo -e "╔════════════════════════════════════════════════════════════════╗"
echo -e "║                                                                ║"
echo -e "║     ${BOLD}Encrypted Swap Setup${NC}${CYAN}                                    ║"
echo -e "║                                                                ║"
echo -e "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

print_info "This will encrypt $SWAP_PART with a keyfile"
print_warning "All data on $SWAP_PART will be destroyed!"
echo ""
read -p "Continue? [y/N]: " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Aborted"
    exit 0
fi

echo ""
print_info "Setting up encrypted swap with keyfile..."

# Disable swap
print_info "Disabling swap..."
swapoff -a

# Create keyfile
print_info "Creating keyfile at /root/swap.key..."
dd bs=512 count=4 if=/dev/random of=/root/swap.key iflag=fullblock
chmod 000 /root/swap.key

# Encrypt swap partition with keyfile
print_info "Encrypting swap partition $SWAP_PART..."
cryptsetup luksFormat --type luks2 "$SWAP_PART" /root/swap.key

# Get the NEW UUID after encryption
print_info "Getting encrypted partition UUID..."
ENCRYPTED_UUID=$(blkid -s UUID -o value "$SWAP_PART")

if [[ -z "$ENCRYPTED_UUID" ]]; then
    print_error "Failed to get UUID of encrypted partition"
    exit 1
fi

# Open encrypted swap
print_info "Opening encrypted swap..."
cryptsetup open "$SWAP_PART" cryptswap --key-file /root/swap.key

# Format as swap
print_info "Formatting encrypted swap..."
mkswap /dev/mapper/cryptswap

# Enable it
print_info "Enabling encrypted swap..."
swapon /dev/mapper/cryptswap

# Update hardware-configuration.nix
print_info "Updating hardware configuration..."
# Backup first
cp /etc/nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix.backup

# Remove the old swapDevices line and closing brace
sed -i '/swapDevices/d' /etc/nixos/hardware-configuration.nix
sed -i '$ d' /etc/nixos/hardware-configuration.nix

# Add encrypted swap configuration
cat >> /etc/nixos/hardware-configuration.nix << EOF

  # Encrypted Swap Configuration
  boot.initrd.luks.devices.cryptswap = {
    device = "/dev/disk/by-uuid/${ENCRYPTED_UUID}";
    keyFile = "/root/swap.key";
    allowDiscards = true;
  };

  # Include the keyfile in initrd
  boot.initrd.secrets = {
    "/root/swap.key" = "/root/swap.key";
  };

  # Encrypted swap device
  swapDevices = [{ device = "/dev/mapper/cryptswap"; }];
}
EOF

print_success "Configuration updated"

print_info "Rebuilding NixOS configuration..."
nixos-rebuild boot

echo ""
print_success "Encrypted swap setup complete!"
echo ""
print_info "Backup: /etc/nixos/hardware-configuration.nix.backup"
print_info "Keyfile: /root/swap.key"
echo ""
print_warning "Please reboot for changes to take effect: sudo reboot"
echo ""
