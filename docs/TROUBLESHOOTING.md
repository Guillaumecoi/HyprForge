# Troubleshooting Guide

## Installation Issues

### Hyprland kicks back to SDDM login on first boot

**Symptom:** After installation, you select a Hyprland session at SDDM, see a flash of black screen, then get kicked back to the login screen.

**Cause:** Hyprland requires a configuration file to start. A minimal config is installed during installation, but if it's missing or corrupted, Hyprland will fail.

**Solution:**

**First, try the Direct session:**
1. At SDDM, select **"Hyprland (Direct)"**
2. Login with your username and password
3. Open a terminal (SUPER + T)
4. Run Home Manager setup:
   ```bash
   cd ~/HyprForge/install && bash post-install.sh
   ```
5. After completion (5-15 minutes), logout and login again
6. Now select **"Hyprland"** (the Home Manager version)

**If Direct session also fails:**
```bash
# Press CTRL + ALT + F2 to get to TTY
# Login with your username

# Check if minimal config exists
ls -la ~/.config/hypr/hyprland.conf

# If missing, reinstall it
mkdir -p ~/.config/hypr
cp ~/HyprForge/share/minimal-hyprland.conf ~/.config/hypr/hyprland.conf

# Now try Home Manager setup
cd ~/HyprForge/install
bash post-install.sh

# Return to graphical login
# Press CTRL + ALT + F1
```

**Understanding the two sessions:**
- **Hyprland (Direct)**: Basic Hyprland with minimal config - always works, use for emergency/setup
- **Hyprland**: Full-featured with Home Manager config - use this after running post-install.sh

### Black screen after boot

- Try `CTRL + ALT + F2` for a TTY console
- Login and run `journalctl -b` to check errors
- If NVIDIA, ensure `hasNvidiaGpu = true` in user.nix

### No network after install

```bash
sudo systemctl start NetworkManager
sudo nmtui
```

### Installer fails to download

- Check internet: `ping google.com`
- Try again with better connection
- Consider manual installation steps from the [NixOS manual](https://nixos.org/manual/nixos/stable/#sec-installation)

### Wrong keyboard layout

Edit [home/programs/hyprland/hyprland.nix](../home/programs/hyprland/hyprland.nix) and update the `kb_layout` option.

## System Issues

### Application won't start

Check if it's installed in [home/packages.nix](../home/packages.nix) and rebuild:

```bash
sudo nixos-rebuild switch
```

### Keybinding not working

Verify it's defined in [home/keybindings/](../home/keybindings/) and run:

```bash
homeswitch
```

### Theme not applied

Some applications require a manual restart after theme changes:

```bash
sudo nixos-rebuild switch
# Then restart the application
```

## Performance Issues

### High RAM usage

Check running processes:

```bash
htop
```

All running services should be declared in your config. Review [system/services.nix](../system/services.nix).

### Slow boot times

Check boot time breakdown:

```bash
systemd-analyze blame
```

## Manual Installation (Advanced)

If the automated script doesn't work for your setup:

1. Follow the [official NixOS manual](https://nixos.org/manual/nixos/stable/#sec-installation)
2. After partitioning and mounting to `/mnt`:

```bash
# Clone config
nix-shell -p git
git clone https://github.com/GuillaumeCoi/HyprForge.git /mnt/etc/nixos

# Generate hardware config
nixos-generate-config --root /mnt --show-hardware-config > /mnt/etc/nixos/hardware-configuration.nix

# Edit user.nix with your settings
nano /mnt/etc/nixos/user.nix

# Install
nixos-install --flake /mnt/etc/nixos#YOUR_HOSTNAME

# Set password
nixos-enter --root /mnt -c "passwd USERNAME"

# Reboot
reboot
```

## Getting Help

- Check [NixOS Discourse](https://discourse.nixos.org/)
- Review [NixOS Wiki](https://nixos.wiki/)
- Open an issue on GitHub
