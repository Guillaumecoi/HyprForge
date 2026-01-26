#!/usr/bin/env bash
#
# NixOS Dotfiles Installation Script
# Run this from the NixOS live USB installer
#
# Usage: curl -L https://raw.githubusercontent.com/YOUR_USERNAME/HyprForge/main/install/install.sh | bash
#    or: bash install.sh
#

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Configuration variables (populated by prompts)
TARGET_DISK=""
SWAP_SIZE_GB=""
ENCRYPT_OS="false"
USERNAME=""
HOSTNAME=""
HAS_NVIDIA=""
GIT_NAME=""
GIT_EMAIL=""

print_banner() {
    echo -e "${CYAN}"
    echo -e "╔════════════════════════════════════════════════════════════════╗"
    echo -e "║                                                                ║"
    echo -e "║     ${BOLD}NixOS Dotfiles Installer${NC}${CYAN}                ║"
    echo -e "║     Hyprland + Catppuccin + Neovim + More                      ║"
    echo -e "║                                                                ║"
    echo -e "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "\n${BLUE}[${1}]${NC} ${BOLD}${2}${NC}"
}

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

confirm() {
    echo -e -n "${YELLOW}$1 [y/N]: ${NC}"
    read -r response
    [[ "$response" =~ ^[Yy]$ ]]
}

# Check if running as root
check_root() {
    if [[ $EUID -ne 0 ]]; then
        print_error "This script must be run as root (use sudo)"
        exit 1
    fi
}

# Check if running from NixOS installer
check_nixos_installer() {
    if ! command -v nixos-install &> /dev/null; then
        print_error "This script must be run from a NixOS installer environment"
        print_info "Boot from a NixOS USB/ISO and run this script"
        exit 1
    fi
}

# List available disks
list_disks() {
    print_step "1/7" "Available disks"
    echo ""
    lsblk -d -o NAME,SIZE,MODEL,TYPE | grep disk | nl -w2 -s') '
    echo ""
}

# Prompt for disk selection
select_disk() {
    local disks
    disks=($(lsblk -d -n -o NAME | grep -E '^(sd|nvme|vd)'))

    if [[ ${#disks[@]} -eq 0 ]]; then
        print_error "No disks found!"
        exit 1
    fi

    while true; do
        echo -e "${CYAN}Enter the disk name (e.g., sda, nvme0n1): ${NC}"
        read -r disk_name

        # Validate disk exists
        if [[ ! -b "/dev/${disk_name}" ]]; then
            print_error "Disk /dev/${disk_name} does not exist. Please try again."
            continue
        fi

        TARGET_DISK="/dev/${disk_name}"

        # Show disk info
        echo ""
        print_warning "Selected disk: ${TARGET_DISK}"
        lsblk "${TARGET_DISK}" -o NAME,SIZE,TYPE,MOUNTPOINT 2>/dev/null || true
        echo ""

        print_warning "ALL DATA ON ${TARGET_DISK} WILL BE DESTROYED!"
        if confirm "Are you absolutely sure?"; then
            break
        else
            print_info "Let's try again..."
        fi
    done
}

# Prompt for swap size
select_swap() {
    print_step "2/7" "Swap Configuration"

    # Get RAM size for recommendation
    local ram_gb
    ram_gb=$(free -g | awk '/^Mem:/{print $2}')

    print_info "Your system has ${ram_gb}GB RAM"
    print_info "Recommended swap: ${ram_gb}GB (for hibernation) or $((ram_gb / 2))GB (general use)"
    echo ""

    while true; do
        echo -e "${CYAN}Enter swap size in GB (0 for no swap): ${NC}"
        read -r swap_input

        if [[ ! "$swap_input" =~ ^[0-9]+$ ]]; then
            print_error "Invalid input. Please enter a number."
            continue
        fi

        SWAP_SIZE_GB=$swap_input
        break
    done

    if [[ $SWAP_SIZE_GB -eq 0 ]]; then
        print_info "No swap partition will be created"
    else
        print_info "Swap size: ${SWAP_SIZE_GB}GB"
    fi
}

# Prompt for disk encryption
select_encryption() {
    print_step "3/7" "Disk Encryption"
    echo ""

    print_info "LUKS full-disk encryption provides security for your data"
    print_info "You will need to enter a passphrase at boot time"
    print_warning "Note: Encryption may slightly impact disk performance"
    echo ""

    echo -e "${CYAN}Enable full-disk encryption (LUKS)? [y/N]: ${NC}"
    read -r encrypt_response

    if [[ "$encrypt_response" =~ ^[Yy]$ ]]; then
        ENCRYPT_OS="true"
        print_info "Full-disk encryption will be enabled"
    else
        ENCRYPT_OS="false"
        print_info "Installation will proceed without encryption"
    fi
}

# Prompt for user configuration
configure_user() {
    print_step "4/7" "User Configuration"
    echo ""

    while true; do
        echo -e "${CYAN}Enter your username: ${NC}"
        read -r USERNAME
        if [[ -z "$USERNAME" ]]; then
            print_error "Username cannot be empty. Please try again."
            continue
        fi
        break
    done

    while true; do
        echo -e "${CYAN}Enter hostname for this machine: ${NC}"
        read -r HOSTNAME
        if [[ -z "$HOSTNAME" ]]; then
            print_error "Hostname cannot be empty. Please try again."
            continue
        fi
        break
    done

    echo -e "${CYAN}Do you have an NVIDIA GPU? [y/N]: ${NC}"
    read -r nvidia_response
    if [[ "$nvidia_response" =~ ^[Yy]$ ]]; then
        HAS_NVIDIA="true"
    else
        HAS_NVIDIA="false"
    fi

    # Git configuration will be set up later
    GIT_NAME=""
    GIT_EMAIL=""

    echo ""
    print_info "Username: ${USERNAME}"
    print_info "Hostname: ${HOSTNAME}"
    print_info "NVIDIA GPU: ${HAS_NVIDIA}"
}

# Show installation summary
show_summary() {
    print_step "5/7" "Installation Summary"
    echo ""
    echo -e "${BOLD}The following will be performed:${NC}"
    echo ""
    echo "  Disk:     ${TARGET_DISK}"
    echo "  Encryption: ${ENCRYPT_OS}"
    echo "  Layout:"
    echo "    - EFI:  512MB (FAT32)"
    if [[ $SWAP_SIZE_GB -gt 0 ]]; then
        echo "    - Swap: ${SWAP_SIZE_GB}GB $(if [[ "${ENCRYPT_OS}" == "true" ]]; then echo "(encrypted)"; fi)"
    fi
    echo "    - Root: Remaining space (ext4 $(if [[ "${ENCRYPT_OS}" == "true" ]]; then echo "encrypted"; fi))"
    echo ""
    echo "  User:     ${USERNAME}"
    echo "  Hostname: ${HOSTNAME}"
    echo "  NVIDIA:   ${HAS_NVIDIA}"
    echo ""

    print_warning "This will ERASE ALL DATA on ${TARGET_DISK}"
    if ! confirm "Proceed with installation?"; then
        print_info "Aborted."
        exit 0
    fi
}

# Partition the disk
partition_disk() {
    print_step "6/7" "Partitioning ${TARGET_DISK}"

    # Determine partition suffix (nvme uses p1, sda uses 1)
    local part_prefix="${TARGET_DISK}"
    if [[ "${TARGET_DISK}" == *"nvme"* ]] || [[ "${TARGET_DISK}" == *"mmcblk"* ]]; then
        part_prefix="${TARGET_DISK}p"
    fi

    # Comprehensive cleanup to prevent "Device busy" errors
    print_info "Performing thorough disk cleanup..."

    # Disable all swaps
    print_info "Disabling swap..."
    swapoff -a 2>/dev/null || true

    # Unmount all partitions from this disk (with force)
    print_info "Unmounting partitions..."
    for mount in $(mount | grep "${TARGET_DISK}" | awk '{print $1}'); do
        umount -l "$mount" 2>/dev/null || true
    done
    umount -l "${TARGET_DISK}"* 2>/dev/null || true

    # Deactivate all LVM volumes on this disk
    print_info "Deactivating LVM volumes..."
    for vg in $(pvs --noheadings -o vg_name 2>/dev/null | sort -u); do
        if [[ -n "$vg" ]] && [[ "$vg" != "" ]]; then
            vgchange -an "$vg" 2>/dev/null || true
            vgremove -f "$vg" 2>/dev/null || true
        fi
    done

    # Remove physical volumes
    for part in ${TARGET_DISK}*; do
        pvremove -ff "$part" 2>/dev/null || true
    done
    pvremove -ff "${TARGET_DISK}" 2>/dev/null || true

    # Close all LUKS/encrypted devices
    print_info "Closing encrypted devices..."
    for mapper in /dev/mapper/*; do
        if [[ -e "$mapper" ]] && cryptsetup status "$(basename "$mapper")" 2>/dev/null | grep -q "${TARGET_DISK}"; then
            print_info "Closing $(basename "$mapper")..."
            cryptsetup close "$(basename "$mapper")" 2>/dev/null || true
        fi
    done

    # Remove all device mapper devices related to this disk
    print_info "Removing device mapper devices..."
    for dm in $(dmsetup ls | grep -E "${TARGET_DISK##*/}" | awk '{print $1}'); do
        dmsetup remove "$dm" 2>/dev/null || true
    done

    # Final check and removal
    dmsetup remove_all 2>/dev/null || true

    # Wait for devices to settle
    sleep 2

    # Zero out the beginning of the disk to clear all signatures
    print_info "Clearing disk signatures..."
    dd if=/dev/zero of="${TARGET_DISK}" bs=1M count=10 status=none 2>/dev/null || true

    # Now wipe filesystem signatures
    print_info "Wiping partition table and signatures..."
    wipefs -af "${TARGET_DISK}" 2>/dev/null || true

    # Additional cleanup for partitions
    for part in ${TARGET_DISK}*; do
        if [[ -e "$part" ]]; then
            wipefs -af "$part" 2>/dev/null || true
        fi
    done

    sleep 1

    # Create GPT partition table
    print_info "Creating GPT partition table..."
    parted -s "${TARGET_DISK}" mklabel gpt

    # Calculate partition sizes
    local efi_end="512MB"
    local swap_start="512MB"
    local swap_end=""
    local root_start=""

    if [[ $SWAP_SIZE_GB -gt 0 ]]; then
        swap_end="$((512 + SWAP_SIZE_GB * 1024))MB"
        root_start="${swap_end}"
    else
        root_start="${efi_end}"
    fi

    # Create partitions
    print_info "Creating EFI partition (512MB)..."
    parted -s "${TARGET_DISK}" mkpart ESP fat32 1MB "${efi_end}"
    parted -s "${TARGET_DISK}" set 1 esp on

    if [[ $SWAP_SIZE_GB -gt 0 ]]; then
        print_info "Creating swap partition (${SWAP_SIZE_GB}GB)..."
        parted -s "${TARGET_DISK}" mkpart swap linux-swap "${swap_start}" "${swap_end}"
    fi

    print_info "Creating root partition (remaining space)..."
    if [[ $SWAP_SIZE_GB -gt 0 ]]; then
        parted -s "${TARGET_DISK}" mkpart root ext4 "${root_start}" 100%
    else
        parted -s "${TARGET_DISK}" mkpart root ext4 "${root_start}" 100%
    fi

    # Wait for partitions to appear
    sleep 2
    partprobe "${TARGET_DISK}"
    sleep 1

    # Format partitions
    print_info "Formatting EFI partition..."
    mkfs.fat -F32 "${part_prefix}1"

    if [[ "${ENCRYPT_OS}" == "true" ]]; then
        # Setup LUKS encryption
        print_info "Setting up disk encryption..."
        echo ""
        print_warning "You will be prompted to enter a passphrase for disk encryption"
        print_warning "Choose a strong passphrase - you'll need it every time you boot!"
        echo ""

        # First encrypt root partition (this will ask for passphrase)
        if [[ $SWAP_SIZE_GB -gt 0 ]]; then
            print_info "Encrypting root partition..."
            cryptsetup luksFormat --type luks2 "${part_prefix}3"
            print_info "Opening encrypted root..."
            cryptsetup open "${part_prefix}3" cryptroot
            print_info "Formatting encrypted root..."
            mkfs.ext4 -F /dev/mapper/cryptroot

            # Create a keyfile for automatic swap unlock
            print_info "Creating keyfile for swap encryption..."
            dd bs=512 count=4 if=/dev/random of=/tmp/crypto_keyfile.bin iflag=fullblock 2>/dev/null
            chmod 000 /tmp/crypto_keyfile.bin

            # Encrypt swap with keyfile (no passphrase prompt)
            print_info "Encrypting swap partition with keyfile..."
            cryptsetup luksFormat --type luks2 --key-file /tmp/crypto_keyfile.bin --batch-mode "${part_prefix}2"
            print_info "Opening encrypted swap..."
            cryptsetup open "${part_prefix}2" cryptswap --key-file /tmp/crypto_keyfile.bin
            print_info "Formatting encrypted swap..."
            mkswap /dev/mapper/cryptswap
            print_info "Enabling swap..."
            swapon /dev/mapper/cryptswap
        else
            print_info "Encrypting root partition..."
            cryptsetup luksFormat --type luks2 "${part_prefix}2"
            print_info "Opening encrypted root..."
            cryptsetup open "${part_prefix}2" cryptroot
            print_info "Formatting encrypted root..."
            mkfs.ext4 -F /dev/mapper/cryptroot
        fi

        print_success "Encryption setup complete"
    else
        # No encryption - standard formatting
        if [[ $SWAP_SIZE_GB -gt 0 ]]; then
            print_info "Formatting swap partition..."
            mkswap "${part_prefix}2"
            print_info "Enabling swap..."
            swapon "${part_prefix}2"

            print_info "Formatting root partition..."
            mkfs.ext4 -F "${part_prefix}3"
        else
            print_info "Formatting root partition..."
            mkfs.ext4 -F "${part_prefix}2"
        fi
    fi

    print_success "Partitioning complete"

    # Store partition paths for later
    EFI_PART="${part_prefix}1"
    if [[ "${ENCRYPT_OS}" == "true" ]]; then
        # Use encrypted mapper devices
        if [[ $SWAP_SIZE_GB -gt 0 ]]; then
            SWAP_PART="/dev/mapper/cryptswap"
            ROOT_PART="/dev/mapper/cryptroot"
            CRYPT_SWAP_DEVICE="${part_prefix}2"
            CRYPT_ROOT_DEVICE="${part_prefix}3"
        else
            SWAP_PART=""
            ROOT_PART="/dev/mapper/cryptroot"
            CRYPT_ROOT_DEVICE="${part_prefix}2"
        fi
    else
        # Use regular partitions
        if [[ $SWAP_SIZE_GB -gt 0 ]]; then
            SWAP_PART="${part_prefix}2"
            ROOT_PART="${part_prefix}3"
        else
            SWAP_PART=""
            ROOT_PART="${part_prefix}2"
        fi
    fi
}

# Mount partitions
mount_partitions() {
    print_info "Mounting partitions..."

    mount "${ROOT_PART}" /mnt
    mkdir -p /mnt/boot
    mount "${EFI_PART}" /mnt/boot

    print_success "Partitions mounted"
}

# Clone and configure the dotfiles
setup_dotfiles() {
    print_step "7/7" "Setting up NixOS configuration"

    # Clone the repository
    print_info "Cloning HyprForge repository..."

    # Clone from GitHub
    nix-shell -p git --run "git clone https://github.com/GuillaumeCoi/HyprForge.git /mnt/etc/nixos"

    # Generate hardware configuration
    print_info "Generating hardware configuration..."
    nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix

    # Get swap UUID if swap exists
    # For encrypted swap, leave empty (null) since hardware-configuration.nix handles it
    # For unencrypted swap, get the partition UUID for configuration.nix to use
    local swap_uuid=""
    if [[ -n "${SWAP_PART}" ]] && [[ "${ENCRYPT_OS}" != "true" ]]; then
        swap_uuid=$(blkid -s UUID -o value "${SWAP_PART}")
    fi

    # If encryption is enabled, check if LUKS is already configured
    if [[ "${ENCRYPT_OS}" == "true" ]]; then
        print_info "Checking LUKS encryption configuration..."

        # Check if nixos-generate-config already added LUKS configuration
        if grep -q "boot.initrd.luks.devices" /mnt/etc/nixos/hardware-configuration.nix; then
            print_info "LUKS configuration already present (auto-detected by nixos-generate-config)"
        else
            print_info "Adding LUKS encryption configuration..."

            # Get UUIDs of encrypted devices
            local root_uuid
            root_uuid=$(blkid -s UUID -o value "${CRYPT_ROOT_DEVICE}")

            # Insert LUKS configuration before the closing brace
            # Remove the last closing brace temporarily
            sed -i '$ d' /mnt/etc/nixos/hardware-configuration.nix

            # Add LUKS configuration
            cat >> /mnt/etc/nixos/hardware-configuration.nix << EOF

  # LUKS Encryption Configuration
  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/disk/by-uuid/${root_uuid}";
      preLVM = true;
    };
EOF

            if [[ $SWAP_SIZE_GB -gt 0 ]]; then
                local swap_uuid_crypt
                swap_uuid_crypt=$(blkid -s UUID -o value "${CRYPT_SWAP_DEVICE}")
                cat >> /mnt/etc/nixos/hardware-configuration.nix << EOF
    cryptswap = {
      device = "/dev/disk/by-uuid/${swap_uuid_crypt}";
      keyFile = "/crypto_keyfile.bin";
    };
EOF
            fi

            # Close the LUKS devices block
            cat >> /mnt/etc/nixos/hardware-configuration.nix << EOF
  };
EOF

            # Add keyfile to initrd if swap is encrypted
            if [[ $SWAP_SIZE_GB -gt 0 ]]; then
                cat >> /mnt/etc/nixos/hardware-configuration.nix << EOF

  # Include the keyfile in initrd
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = "/crypto_keyfile.bin";
  };
EOF
            fi

            # Close the main config
            cat >> /mnt/etc/nixos/hardware-configuration.nix << EOF
}
EOF

            # Copy keyfile to the mounted root if swap is encrypted
            if [[ $SWAP_SIZE_GB -gt 0 ]]; then
                print_info "Installing keyfile to system..."
                cp /tmp/crypto_keyfile.bin /mnt/crypto_keyfile.bin
                chmod 000 /mnt/crypto_keyfile.bin
                rm /tmp/crypto_keyfile.bin
            fi
        fi
    fi

    # Create user.nix
    print_info "Creating user configuration..."
    cat > /mnt/etc/nixos/user.nix << EOF
{
  # Hostname and username configuration
  username = "${USERNAME}";
  hostname = "${HOSTNAME}";

  # System-specific hardware configuration
  hasNvidiaGpu = ${HAS_NVIDIA};

  # Swap configuration
  swapDevice = $(if [[ -n "${swap_uuid}" ]]; then echo "\"/dev/disk/by-uuid/${swap_uuid}\""; else echo "null"; fi);
  swapSizeGB = ${SWAP_SIZE_GB};

  # Printer configuration (empty list = no printing)
  printerDrivers = [];

  # Git configuration (to be configured later)
  git = {
    fullName = "";
    email = "";
  };
}
EOF

    print_success "Configuration created"
}

# Install NixOS
install_nixos() {
    print_step "8/9" "Installing NixOS"

    print_info "This may take 15-30 minutes depending on your internet speed..."
    echo ""

    # Run nixos-install
    nixos-install --flake /mnt/etc/nixos#"${HOSTNAME}" --no-root-passwd

    print_success "NixOS installation complete!"
}

# Set user password
set_password() {
    echo ""
    print_info "Setting password for ${USERNAME}..."
    nixos-enter --root /mnt -c "passwd ${USERNAME}"
}

# Setup home-manager for the user
setup_home_manager() {
    print_step "9/9" "Setting up Home Manager"

    print_info "Copying HyprForge to user home directory..."

    # Create the user's home directory structure if it doesn't exist
    mkdir -p "/mnt/home/${USERNAME}"

    # Copy the entire configuration to user's home as HyprForge
    cp -r /mnt/etc/nixos "/mnt/home/${USERNAME}/HyprForge"

    # Set ownership to the user
    nixos-enter --root /mnt -c "chown -R ${USERNAME}:users /home/${USERNAME}/HyprForge"

    print_success "HyprForge copied to /home/${USERNAME}/HyprForge"

    # Create a post-install setup script for the user
    print_info "Creating post-install setup script..."

    cat > "/mnt/home/${USERNAME}/.setup-home-manager.sh" << 'SETUPEOF'
#!/usr/bin/env bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${CYAN}"
echo -e "╔════════════════════════════════════════════════════════════════╗"
echo -e "║                                                                ║"
echo -e "║     ${BOLD}HyprForge Home Manager Setup${NC}${CYAN}                           ║"
echo -e "║                                                                ║"
echo -e "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

echo -e "${BLUE}[1/3]${NC} ${BOLD}Initializing Home Manager...${NC}"
echo -e "${CYAN}  → ${NC}This will set up your user environment and applications"
echo ""

# Check if HyprForge directory exists
if [[ ! -d "$HOME/HyprForge" ]]; then
    echo -e "${RED}  ✗ ${NC}HyprForge directory not found in $HOME"
    echo -e "${YELLOW}  ⚠ ${NC}Please ensure /home/$(whoami)/HyprForge exists"
    exit 1
fi

cd "$HOME/HyprForge" || exit 1

echo -e "${BLUE}[2/3]${NC} ${BOLD}Running Home Manager switch...${NC}"
echo -e "${CYAN}  → ${NC}This may take 5-10 minutes on first run"
echo ""

# Run home-manager switch with the flake
if home-manager switch --flake "$HOME/HyprForge#$(whoami)@$(hostname)"; then
    echo -e "${GREEN}  ✓ ${NC}Home Manager setup complete!"
else
    echo -e "${RED}  ✗ ${NC}Home Manager setup failed"
    echo -e "${YELLOW}  ⚠ ${NC}You may need to run this manually:"
    echo -e "      cd ~/HyprForge && home-manager switch --flake .#$(whoami)@$(hostname)"
    exit 1
fi

echo ""
echo -e "${BLUE}[3/3]${NC} ${BOLD}Finalizing setup...${NC}"

# Remove this setup script
rm -f "$HOME/.setup-home-manager.sh"

echo ""
echo -e "${GREEN}"
echo -e "╔════════════════════════════════════════════════════════════════╗"
echo -e "║                                                                ║"
echo -e "║     ${BOLD}Setup Complete!${NC}${GREEN}                                        ║"
echo -e "║                                                                ║"
echo -e "╚════════════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

echo -e "${CYAN}  → ${NC}All user applications and settings are now active!"
echo -e "${CYAN}  → ${NC}Press ${BOLD}SUPER + T${NC} for terminal (kitty)"
echo -e "${CYAN}  → ${NC}Press ${BOLD}SUPER + Q${NC} for another terminal"
echo -e "${CYAN}  → ${NC}Press ${BOLD}SUPER + A${NC} for application launcher"
echo -e "${CYAN}  → ${NC}Press ${BOLD}SUPER + SLASH${NC} to see all keybindings"
echo ""
echo -e "${YELLOW}  ⚠ ${NC}You may need to ${BOLD}logout and login${NC} or ${BOLD}reboot${NC} for all changes to take effect"
echo ""

read -p "Press Enter to continue..."

SETUPEOF

    chmod +x "/mnt/home/${USERNAME}/.setup-home-manager.sh"
    nixos-enter --root /mnt -c "chown ${USERNAME}:users /home/${USERNAME}/.setup-home-manager.sh"

    print_success "Post-install script created"

    # Try to run home-manager setup now (this might fail if home-manager isn't available in the live environment)
    print_info "Attempting to initialize Home Manager now..."
    echo ""

    if nixos-enter --root /mnt -c "su - ${USERNAME} -c 'cd ~/HyprForge && home-manager switch --flake .#${USERNAME}@${HOSTNAME}'" 2>/dev/null; then
        print_success "Home Manager initialized successfully!"
        # Remove the setup script since we don't need it anymore
        rm -f "/mnt/home/${USERNAME}/.setup-home-manager.sh"
    else
        print_warning "Could not initialize Home Manager during installation"
        print_info "A setup script has been created at ~/.setup-home-manager.sh"
        print_info "It will run automatically on first login, or you can run it manually"
    fi
}

# Final message
print_complete() {
    echo ""
    echo -e "${GREEN}"
    echo -e "╔════════════════════════════════════════════════════════════════╗"
    echo -e "║                                                                ║"
    echo -e "║     ${BOLD}Installation Complete!${NC}${GREEN}                 ║"
    echo -e "║                                                                ║"
    echo -e "╚════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
    print_info "Your NixOS system with Hyprland is ready!"
    echo ""
    print_info "Next steps:"
    echo -e "  1. Reboot: ${BOLD}reboot${NC}"
    echo -e "  2. Login with username: ${BOLD}${USERNAME}${NC}"

    # Check if the setup script still exists
    if [[ -f "/mnt/home/${USERNAME}/.setup-home-manager.sh" ]]; then
        echo -e "  3. Run the setup script: ${BOLD}~/.setup-home-manager.sh${NC}"
        echo -e "     ${YELLOW}(This will complete Home Manager setup)${NC}"
        echo -e "  4. Press ${BOLD}SUPER + T${NC} for terminal"
        echo -e "  5. Press ${BOLD}SUPER + A${NC} for application launcher"
        echo -e "  6. Press ${BOLD}SUPER + SLASH${NC} to see all keybindings"
    else
        echo -e "  3. Press ${BOLD}SUPER + T${NC} for terminal"
        echo -e "  4. Press ${BOLD}SUPER + A${NC} for application launcher"
        echo -e "  5. Press ${BOLD}SUPER + SLASH${NC} to see all keybindings"
    fi

    echo ""
    print_info "System config: /etc/nixos"
    print_info "User config: ~/HyprForge"
    print_info "To rebuild system: ${BOLD}sudo nixos-rebuild switch --flake /etc/nixos#${HOSTNAME}${NC}"
    print_info "To rebuild user env: ${BOLD}home-manager switch --flake ~/HyprForge#${USERNAME}@${HOSTNAME}${NC}"
    echo ""

    if confirm "Reboot now?"; then
        umount -R /mnt
        reboot
    fi
}

# Main installation flow
main() {
    print_banner
    check_root
    check_nixos_installer

    list_disks
    select_disk
    select_swap
    select_encryption
    configure_user
    show_summary

    partition_disk
    mount_partitions
    setup_dotfiles
    install_nixos
    set_password
    setup_home_manager

    print_complete
}

main "$@"
