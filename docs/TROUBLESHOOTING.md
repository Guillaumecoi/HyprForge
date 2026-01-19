# Troubleshooting Guide

## Installation Issues

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
