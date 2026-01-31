# System Configuration

System-level NixOS modules for packages, fonts, and services.

## Modules

- **packages.nix** - System-wide packages (hardware tools, core utilities)
- **fonts.nix** - Nerd Fonts, system fonts, emoji fonts
- **services.nix** - Pipewire, printing, networking, etc.
- **sddm.nix** - Display manager and Wayland session

## System vs Home

- **System**: Hardware control, services, shared utilities
- **Home**: User apps, dev tools, personal config

## Hardware Configuration

Conditional settings via `user.nix`:

```nix
# NVIDIA GPU
hasNvidiaGpu = true;

# Printing
printerDrivers = [ "epson-escpr2" ];
```

**Note:** Swap is handled automatically by `hardware-configuration.nix`.

## Rebuilding

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```
