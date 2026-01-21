# NixOS Dotfiles Installation Guide

This guide walks you through installing NixOS with this configuration on a new machine.

## Prerequisites

- A USB drive (4GB+) for the NixOS installer
- The target machine with UEFI boot support
- Internet connection during installation
- 30-60 minutes

## Step 1: Create NixOS Installer USB

On any Linux machine:

```bash
# Download the latest NixOS minimal ISO
wget https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso >> install.sh
sudo bash install.sh

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
sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/GuillaumeCoi/HyprForge/main/install/install.sh)"
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

## Step 6: Reboot

After installation completes:

```bash
reboot
```

Remove the USB drive when prompted. Your system will boot into the new NixOS installation.

## First Login

1. Log in with your username and password
2. You'll be in Hyprland (the window manager)
3. Press `SUPER + F1` to see all keybindings
4. Press `SUPER + T` for a terminal
5. Press `SUPER + A` for the application launcher

## Next Steps

- **[Usage Guide](../docs/USAGE.md)** - Learn how to customize your system
- **[Keybindings](../docs/KEYBINDINGS.md)** - Complete keybinding reference
- **[FAQ](../docs/FAQ.md)** - Frequently asked questions
- **[Troubleshooting](../docs/TROUBLESHOOTING.md)** - Common issues and solutions

## Disk Layout

The installer creates this partition scheme:

**Without encryption:**

| Partition | Size         | Type       | Mount |
| --------- | ------------ | ---------- | ----- |
| EFI       | 512MB        | FAT32      | /boot |
| Swap      | User-defined | Linux swap | -     |
| Root      | Remaining    | ext4       | /     |

**With LUKS encryption enabled:**

| Partition | Size         | Type            | Mount |
| --------- | ------------ | --------------- | ----- |
| EFI       | 512MB        | FAT32           | /boot |
| Swap      | User-defined | Encrypted swap  | -     |
| Root      | Remaining    | Encrypted ext4  | /     |

Both swap and root partitions are encrypted with LUKS2. You'll enter your passphrase once at boot to unlock both.

For custom layouts (LVM, btrfs, etc.), manual installation is recommended.
