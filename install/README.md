# NixOS Dotfiles Installation Guide

This guide walks you through installing NixOS with this configuration on a new machine.

## Video Tutorial

**Watch the complete installation walkthrough:**

[![HyprForge Installation Tutorial](https://img.youtube.com/vi/3kxDVAS6ph4/mqdefault.jpg)](https://www.youtube.com/watch?v=3kxDVAS6ph4)

*Click to watch: Step-by-step video guide showing the entire installation process from USB creation to first login.*

## Prerequisites

- A USB drive (4GB+) for the NixOS installer
- The target machine with UEFI boot support
- Internet connection during installation
- 30-60 minutes

## Step 1: Create NixOS Installer USB

On any Linux machine:

```bash
# Download the latest NixOS minimal ISO
wget https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso

# Find your USB drive (e.g., /dev/sdb)
lsblk

# Write the ISO to USB (replace /dev/sdX with your USB drive)
sudo dd if=latest-nixos-minimal-x86_64-linux.iso of=/dev/sdX bs=4M status=progress
sync
```

Or use a tool like [Ventoy](https://www.ventoy.net/), [balenaEtcher](https://etcher.balena.io/), or Rufus (Windows).

## Step 2: Boot from USB

1. Insert USB into target machine
2. Enter BIOS/UEFI (usually F2, F12, Del, or Esc during boot)
3. Disable Secure Boot
4. Set USB as first boot device
5. Save and reboot

You should see the NixOS boot menu. Select the default option.

## Step 3: Connect to Internet

Once booted into the NixOS installer:

**For Wi-Fi:**

```bash
# Start interactive network configuration
sudo nmtui
# Select "Activate a connection", choose your network, enter password
```

**For Ethernet:** Should work automatically.

**Verify connection:**

```bash
ping -c 3 google.com
```

## Step 4: Run the Installer

**Option A: Quick install (if you trust this repo)**

```bash
# Download and run the installer
curl https://raw.githubusercontent.com/GuillaumeCoi/HyprForge/main/install/install.sh >> install.sh
sudo bash install.sh
```

**Option B: Manual clone first (recommended to review)**

```bash
# Install git temporarily
nix-shell -p git

# Clone the repository
git clone https://github.com/GuillaumeCoi/HyprForge.git
cd HyprForge

# Review the script if desired
less install/install.sh

# Run the installer
sudo bash install/install.sh
```

## Step 5: Follow the Prompts

The installer will ask you:

1. **Target disk** - Which drive to install on (e.g., `sda` or `nvme0n1`)
   - WARNING: This will ERASE the selected disk!

2. **Swap size** - How much swap space in GB
   - Recommended: Same as your RAM for hibernation support
   - Minimum: Half your RAM for general use
   - Enter 0 for no swap

3. **Disk encryption** - Enable LUKS full-disk encryption
   - Encrypts your root and swap partitions
   - Requires passphrase entry at boot time
   - Provides strong security for your data

4. **Username** - Your login name

5. **Hostname** - Machine name

6. **NVIDIA GPU** - Whether you have an NVIDIA graphics card

7. **Git config** - Your name and email for git commits

8. **Password** - You'll set your user password at the end

## Step 6: Home Manager Setup

The installer automatically:

1. Copies HyprForge to `~/HyprForge`
2. Attempts to set up Home Manager (user environment)

**If Home Manager setup succeeds during installation:**

- You're all set! Skip to Step 7.

**If Home Manager setup is pending:**

- A setup script will be created at `~/.setup-home-manager.sh`
- It will run automatically on first login
- Or you can run it manually after logging in

**If you need to set up Home Manager manually later:**

```bash
# Run the post-install script
bash ~/HyprForge/install/post-install.sh

# Or manually:
cd ~/HyprForge
home-manager switch --flake .#$(whoami)@$(hostname)
```

## Step 7: Reboot

After installation completes:

```bash
reboot
```

Remove the USB drive when prompted. Your system will boot into the new NixOS installation.

## Important: Machine-Specific Files

The installation script generates machine-specific files that are gitignored:

**System-level configuration:**

- `user.nix` - Username, hostname, hardware settings (GPU, printers), swap config
- `hardware-configuration.nix` - Auto-detected hardware (kernel modules, filesystems)

**User-level configuration:**

- `home/home-config.nix` - Git config, monitor settings, personal preferences
- `home/packages.nix` - Your package list (customize what software you want)

**Why gitignored?** These files are unique to each machine and user. The repository stays clean and portable.

**Setting up on a new machine:**

```bash
# After cloning the repo
cp user.nix.example user.nix
cp hardware-configuration.nix.example hardware-configuration.nix
cp home/home-config.nix.example home/home-config.nix
cp home/packages.nix.example home/packages.nix

# Edit each file with your settings
nano user.nix              # System settings
nano home/home-config.nix  # User settings
nano home/packages.nix     # Package selection

# Generate hardware config
sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix

# CRITICAL: Force-add gitignored files to git index
# Nix flakes only see files in git, but .gitignore prevents commits
# This adds them to the index locally without committing them
git add -f user.nix home/home-config.nix home/packages.nix
```

## First Login

1. Log in with your username and password
2. If Home Manager wasn't set up yet, run `~/.setup-home-manager.sh` (or it may run automatically)
3. You'll be in Hyprland (the window manager)
4. Press `SUPER + SLASH` to see all keybindings
5. Press `SUPER + T` for a terminal (kitty)
6. Press `SUPER + A` for the application launcher

## Next Steps

- **[Usage Guide](../docs/USAGE.md)** - Learn how to customize your system
- **[Keybindings](../docs/KEYBINDINGS.md)** - Complete keybinding reference
- **[FAQ](../docs/FAQ.md)** - Frequently asked questions
- **[Troubleshooting](../docs/TROUBLESHOOTING.md)** - Common issues and solutions

## Post-Installation: Setting Up an Existing System

If you already installed NixOS but didn't run the full installer (or Home Manager wasn't set up), use the post-install script:

```bash
# Option 1: If you already have HyprForge in /etc/nixos
bash /etc/nixos/install/post-install.sh

# Option 2: Clone fresh and run
git clone https://github.com/GuillaumeCoi/HyprForge.git ~/HyprForge
bash ~/HyprForge/install/post-install.sh

# Option 3: Manual setup
cp -r /etc/nixos ~/HyprForge  # Copy config to home
cd ~/HyprForge
home-manager switch --flake .#$(whoami)@$(hostname)
```

This will:

- Copy HyprForge to your home directory
- Set up Home Manager with all user applications
- Configure Hyprland, kitty, and all other user-level tools

## Understanding the Two-Part Installation

HyprForge uses a two-part configuration:

1. **System Configuration** (`/etc/nixos/`)
   - Base system packages and services
   - Requires root/sudo to modify
   - Updated with: `sudo nixos-rebuild switch --flake /etc/nixos#hostname`

2. **User Configuration** (`~/HyprForge/`)
   - User applications (kitty, firefox, rofi, etc.)
   - Hyprland settings and keybindings
   - Per-user customization
   - Updated with: `home-manager switch --flake ~/HyprForge#user@hostname`

Both configurations work together to provide the complete HyprForge experience.

## Disk Layout

The installer creates this partition scheme:

**Without encryption:**

| Partition | Size         | Type       | Mount |
| --------- | ------------ | ---------- | ----- |
| EFI       | 512MB        | FAT32      | /boot |
| Swap      | User-defined | Linux swap | -     |
| Root      | Remaining    | ext4       | /     |

**With LUKS encryption enabled:**

| Partition | Size         | Type           | Mount |
| --------- | ------------ | -------------- | ----- |
| EFI       | 512MB        | FAT32          | /boot |
| Swap      | User-defined | Encrypted swap | -     |
| Root      | Remaining    | Encrypted ext4 | /     |

Both swap and root partitions are encrypted with LUKS2. You'll enter your passphrase once at boot to unlock both.

For custom layouts (LVM, btrfs, etc.), manual installation is recommended.
