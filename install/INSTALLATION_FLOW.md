# HyprForge Installation Flow Documentation

## Overview
This document describes the complete installation flow for HyprForge NixOS configuration with LUKS encryption.

## Installation Scripts

### 1. install.sh (Main Installer)
**Location:** `/install/install.sh`
**Runs:** During NixOS live USB installation
**Purpose:** Partition disk, install NixOS base system, set up encryption

**Key Features:**
- Interactive prompts for disk, swap size, encryption, username, hostname
- Single password prompt for LUKS root encryption (not swap)
- Partitioning: EFI (512MB) + optional swap + root
- Clones HyprForge repository to `/etc/nixos`
- Generates hardware-configuration.nix
- Installs base NixOS system
- Sets user password
- Copies helper scripts for post-installation

**Encryption Behavior:**
- If encryption enabled: Only encrypts ROOT partition during install
- Swap is left UNENCRYPTED during installation
- Copies `setup-encrypted-swap.sh` to `/root/` for post-install use

### 2. post-install.sh (Home Manager Setup)
**Location:** `/install/post-install.sh`
**Runs:** After first boot, as regular user
**Purpose:** Initialize Home Manager for user environment

**Key Features:**
- Clones HyprForge to user's home directory
- Backs up example configs
- Runs `home-manager switch` with flake

**Usage:**
```bash
cd ~/HyprForge/install
bash post-install.sh
```

### 3. setup-encrypted-swap.sh (Swap Encryption)
**Location:** `/install/setup-encrypted-swap.sh`
**Runs:** After first boot, as root (OPTIONAL)
**Purpose:** Encrypt swap partition with keyfile

**Key Features:**
- Takes swap partition as CLI argument
- Creates keyfile at `/root/swap.key` (chmod 000)
- Encrypts swap with LUKS2 using keyfile
- Opens and formats encrypted swap
- Updates `hardware-configuration.nix` with LUKS swap config
- Rebuilds NixOS with `nixos-rebuild boot`
- Requires reboot after completion

**Usage:**
```bash
sudo /root/setup-encrypted-swap.sh /dev/nvme0n1p2
```

## Complete Installation Flow

### Phase 1: Boot Live USB
1. Boot NixOS live USB
2. Become root: `sudo -i`
3. Run install script: `bash install.sh`

### Phase 2: Main Installation (install.sh)
1. **Disk Selection** - Choose target disk
2. **Swap Configuration** - Specify swap size (0 to skip)
3. **Encryption** - Enable/disable LUKS encryption
4. **User Configuration** - Username, hostname, NVIDIA support
5. **Summary & Confirmation** - Review settings
6. **Partitioning** - Create EFI, swap (optional), root partitions
7. **Encryption Setup** - Encrypt root partition ONLY (single password prompt)
8. **Mounting** - Mount partitions
9. **Dotfiles Setup**:
   - Clone HyprForge to `/mnt/etc/nixos`
   - Generate `hardware-configuration.nix`
   - Add LUKS config for root
   - Copy `setup-encrypted-swap.sh` to `/mnt/root/`
10. **NixOS Installation** - Run `nixos-install`
11. **Password Setup** - Set user password
12. **Home Manager Prep** - Copy HyprForge to user's home
13. **Minimal Config** - Install basic Hyprland config to `~/.config/hypr/`
14. **Auto-setup Script** - Create `.setup-home-manager.sh` for first login
15. **Reboot**

### Phase 3: First Boot

1. System boots (enter LUKS password if encrypted)
2. Login at SDDM with username/password
3. **Select "Hyprland (Direct)" session** (not just "Hyprland")
4. You'll boot into a basic Hyprland desktop
5. Terminal opens automatically with Home Manager setup
6. Setup downloads and installs packages (5-15 minutes)
7. After completion, logout

### Phase 4: Using Full Configuration

1. Login again at SDDM
2. **Now select "Hyprland"** (without "Direct")
3. Full-featured desktop with all your configurations!

**Two Hyprland Sessions Explained:**
- **Hyprland (Direct)**: Basic config, always works, use for first boot and emergencies
- **Hyprland**: Full Home Manager config, use after running post-install.sh

### Phase 5: Manual Setup (if auto-setup fails)
```bash
cd ~/HyprForge/install
bash post-install.sh
```
- Sets up Home Manager
- Installs user packages and configs
- Configures Hyprland, Waybar, terminals, etc.

### Phase 5: Swap Encryption (OPTIONAL)
If swap was created and encryption is desired:
```bash
sudo /root/setup-encrypted-swap.sh /dev/nvme0n1p2
```
- Encrypts swap with keyfile
- Updates hardware config
- Rebuilds system
- **Reboot required**

After reboot: Swap is encrypted and automatically unlocked via keyfile

## Directory Structure After Installation

### On Live USB (during install.sh)
```
/mnt/
├── boot/          # EFI partition mounted
├── etc/nixos/     # HyprForge cloned here
│   ├── configuration.nix
│   ├── hardware-configuration.nix
│   ├── flake.nix
│   ├── install/
│   │   ├── install.sh
│   │   ├── post-install.sh
│   │   └── setup-encrypted-swap.sh
│   └── ...
└── root/
    └── setup-encrypted-swap.sh  # Copy for post-install
```

### After First Boot
```
System config: /etc/nixos/ (HyprForge repo)
User config: ~/HyprForge/ (Home Manager)
Swap script: /root/setup-encrypted-swap.sh (if encrypted root)
```

## Partition Layouts

### Without Swap
```
/dev/sdX1 → 512MB EFI (FAT32)
/dev/sdX2 → Remaining (ext4, optionally LUKS encrypted)
```

### With Swap, No Encryption
```
/dev/sdX1 → 512MB EFI (FAT32)
/dev/sdX2 → XGB Swap
/dev/sdX3 → Remaining (ext4)
```

### With Swap, With Encryption (During Install)
```
/dev/sdX1 → 512MB EFI (FAT32)
/dev/sdX2 → XGB Swap (UNENCRYPTED initially)
/dev/sdX3 → Remaining (LUKS → ext4)
```

### With Swap, With Encryption (After Post-Install Script)
```
/dev/sdX1 → 512MB EFI (FAT32)
/dev/sdX2 → XGB Swap (LUKS → swap, keyfile)
/dev/sdX3 → Remaining (LUKS → ext4, password)
```

## Password Prompts

### During Installation (install.sh)
- **1 password prompt** for root partition encryption (if enabled)
- User password set at end via `nixos-install`

### At Boot (after install)
- **1 password prompt** for unlocking encrypted root
- Swap unlocks automatically via keyfile (if encrypted post-install)

### NO Password Prompts For:
- Swap during installation (left unencrypted)
- Swap after encryption (keyfile auto-unlocks)

## Key Files Modified

### hardware-configuration.nix
- Generated by `nixos-generate-config`
- Modified by install.sh to add root LUKS config
- Modified by setup-encrypted-swap.sh to add swap LUKS config

**Root LUKS Config (added by install.sh):**
```nix
boot.initrd.luks.devices.cryptroot = {
  device = "/dev/disk/by-uuid/XXXXXXXX";
  preLVM = true;
};
```

**Swap LUKS Config (added by setup-encrypted-swap.sh):**
```nix
boot.initrd.luks.devices.cryptswap = {
  device = "/dev/disk/by-uuid/YYYYYYYY";
  keyFile = "/root/swap.key";
  allowDiscards = true;
};

boot.initrd.secrets = {
  "/root/swap.key" = "/root/swap.key";
};

swapDevices = [{ device = "/dev/mapper/cryptswap"; }];
```

## Troubleshooting

### Swap Encryption Script Not Found
**Error:** "Swap encryption script not found in repository"
**Solution:** Ensure `install/setup-encrypted-swap.sh` exists and is executable in HyprForge repo

### Multiple Password Prompts
**Issue:** Being asked for passwords for both root and swap
**Cause:** Old version of install.sh tried to encrypt swap during installation
**Solution:** Use latest install.sh that leaves swap unencrypted until post-install

### Cannot Run Swap Encryption Script
**Error:** Permission denied
**Solution:**
```bash
chmod +x /root/setup-encrypted-swap.sh
sudo /root/setup-encrypted-swap.sh /dev/sdXY
```

### Swap Partition Unknown
**Find swap partition:**
```bash
lsblk
# or
blkid | grep swap
# or
swapon --show
```
## Script Integration

### How install.sh Uses Other Scripts

**setup-encrypted-swap.sh:**
- Copied from repo to `/mnt/root/` during dotfiles setup
- Only copied if encryption enabled AND swap exists
- User instructed to run manually after first boot

**post-install.sh:**
- NOT automatically run by install.sh
- HyprForge cloned to user's home for manual execution
- User instructed to run after first boot and login

### Why This Approach?

**Separation of Concerns:**
- install.sh = system installation (root partition, base NixOS)
- post-install.sh = user environment (Home Manager, user configs)
- setup-encrypted-swap.sh = optional post-install encryption

**Single Password Principle:**
- Only root needs password at boot
- Swap uses keyfile, no user interaction
- Achieved by leaving swap unencrypted until after boot

**Script Modularity:**
- Each script is standalone and testable
- No embedded heredocs creating nested scripts
- Easy to maintain and debug

## Success Criteria

A successful installation meets these criteria:

1. ✅ User prompted for password ONCE during installation (root encryption)
2. ✅ User prompted for password ONCE at boot (unlock root)
3. ✅ Swap unencrypted during installation
4. ✅ Swap encryption available as post-install option
5. ✅ All three scripts are separate files (no scripts-within-scripts)
6. ✅ All scripts pass syntax validation
7. ✅ System boots into Hyprland desktop
8. ✅ User environment set up via Home Manager
9. ✅ (Optional) Swap encrypted with keyfile, auto-unlocked

## Notes

- Keyfile stored at `/root/swap.key` with permissions `000`
- Keyfile included in initrd via `boot.initrd.secrets`
- Encrypted swap device: `/dev/mapper/cryptswap`
- Original hardware-configuration.nix backed up before modifications
- Swap encryption requires reboot to take effect
- Swap encryption is OPTIONAL but recommended for full disk encryption
