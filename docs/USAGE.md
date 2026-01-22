# Usage Guide

Complete guide to using and customizing HyprForge.

## Table of Contents

- [Making Changes](#making-changes)
- [Package Management](#package-management)
- [Keybindings System](#keybindings-system)
- [Adding New Programs](#adding-new-programs)
- [Common Commands](#common-commands)
- [Customization](#customization)

---

## Making Changes

After editing configuration files, rebuild your system:

### System-level changes

```bash
# For changes to configuration.nix, system packages, services, etc.
sudo nixos-rebuild switch --flake ~/HyprForge#$(hostname)

# Or using the shortcut alias (add to your shell config):
alias sysswitch='sudo nixos-rebuild switch --flake ~/HyprForge#$(hostname)'
```

### Home Manager changes

```bash
# For changes to home packages, program configs, keybindings, etc.
home-manager switch --flake ~/HyprForge#$(hostname)

# Or using the shortcut alias:
alias homeswitch='home-manager switch --flake ~/HyprForge#$(hostname)'
```

---

## Package Management

### The Two-File System

**All software is explicitly declared in just two files:**

1. **[home/packages.nix](../home/packages.nix)** - User applications
2. **[system/packages.nix](../system/packages.nix)** - System utilities

This is the core philosophy: **everything visible, nothing hidden**.

### Adding Packages

Edit [home/packages.nix](../home/packages.nix):

```nix
[
  "firefox"
  "spotify"
  "vlc"
  "gimp"        # Add this
  # "blender"   # Comment out to remove
]
```

Then rebuild:

```bash
home-manager switch --flake ~/HyprForge#$(hostname)
```

### Finding Package Names

```bash
# Search for packages
nix search nixpkgs <name>

# Example: find image editors
nix search nixpkgs gimp
```

### The Automatic Home Manager Detection

**This is a unique feature of HyprForge!**

When you add a package to `home/packages.nix`, the system automatically:

1. Checks if the package has a Home Manager module
2. If yes → Enables it with `programs.<name>.enable = true` automatically
3. If no → Installs as a regular package

**Example:**

```nix
[
  "git"      # Has HM module → programs.git.enable = true
  "firefox"  # Has HM module → programs.firefox.enable = true
  "spotify"  # No HM module → installed as regular package
]
```

This means you get Home Manager's benefits (declarative config) without losing the simplicity of a single package list!

### Custom Program Configurations

Programs with custom configs live in [home/programs/](../home/programs/):

```
home/programs/
├── firefox/firefox.nix    # Firefox with extensions & settings
├── kitty/kitty.nix        # Terminal config
├── neovim/neovim.nix      # Vim config & plugins
├── vscode/vscode.nix      # VSCode settings
└── ...
```

These are **automatically imported** by [home.nix](../home.nix). The import system scans the directory and loads all `<name>/<name>.nix` files.

**To customize:**

1. Edit the program's `.nix` file
2. Run `homeswitch`
3. Changes apply immediately

---

## Keybindings System

### Centralized Keybinding Philosophy

**Problem:** Changing `Ctrl+T` for "new tab" requires editing 5+ config files
**Solution:** Define once, auto-apply everywhere

### The Keybindings Directory

Located at [home/keybindings/](../home/keybindings/):

```
keybindings/
├── default.nix      # Main entry point
├── apps.nix         # Default applications
├── local.nix        # App keybindings (CTRL, ALT)
├── global.nix       # Window manager keybindings (SUPER)
└── converters.nix   # Format converters for different apps
```

### Key Philosophy

- **SUPER** - Window manager (Hyprland) - windows, workspaces, launchers
- **CTRL** - Application actions - tabs, save, close, editing
- **ALT** - Quick access - tab numbers, alternative actions

### Defining Keybindings

Edit [home/keybindings/local.nix](../home/keybindings/local.nix):

```nix
{
  # Tab management
  tabs = {
    new = "ctrl+t";
    close = "ctrl+w";
    next = "ctrl+tab";
    prev = "ctrl+shift+tab";
    reopen = "ctrl+shift+t";
  };

  # Editing
  editing = {
    save = "ctrl+s";
    undo = "ctrl+z";
    redo = "ctrl+shift+z";
  };
}
```

### Applying Keybindings to Programs

Programs import and convert keybindings automatically. Example from `programs/kitty/kitty.nix`:

```nix
let
  # Import keybinding system
  kb = import ../../keybindings { inherit lib; };

  # Convert tab keybindings to Kitty format
  keys = kb.toKitty kb.tabs;
in {
  programs.kitty = {
    enable = true;
    keybindings = {
      "${keys.new}" = "new_tab";         # Uses ctrl+t from local.nix
      "${keys.close}" = "close_tab";     # Uses ctrl+w from local.nix
      "${keys.next}" = "next_tab";
    };
  };
}
```

**Supported converters:**

- `kb.toKitty` - Kitty terminal format
- `kb.toYazi` - Yazi file manager format
- `kb.toNeovim` - Neovim/Vim format
- `kb.toVSCode` - VSCode format
- `kb.toFirefox` - Firefox format (limited - Firefox hardcodes many shortcuts)

### Changing Default Applications

Edit [home/keybindings/apps.nix](../home/keybindings/apps.nix):

```nix
{
  terminal = "kitty";      # or "alacritty"
  editor = "code";         # or "nvim"
  browser = "firefox";     # or "brave", "chromium"
  explorer = "kitty -e yazi";  # or "thunar"
  aiCli = "copilot";      # GitHub Copilot CLI
}
```

These propagate to:

- Hyprland keybindings (`SUPER+T` → terminal)
- Environment variables (`$TERMINAL`, `$EDITOR`)
- Script defaults

---

## Adding New Programs

### Simple Package (No Config)

Add to [home/packages.nix](../home/packages.nix):

```nix
[
  "spotify"   # Just add the package name
]
```

### Program with Custom Config

1. **Create the program directory:**

```bash
mkdir -p ~/HyprForge/home/programs/myapp
```

2. **Create `myapp.nix`:**

```nix
{ config, pkgs, lib, ... }:

let
  # Import keybindings if needed
  kb = import ../../keybindings { inherit lib; };
  keys = kb.toMyApp kb.tabs;  # Define your converter
in {
  programs.myapp = {
    enable = true;
    settings = {
      theme = "catppuccin-mocha";
      # ... your config
    };
  };
}
```

3. **Rebuild:**

```bash
homeswitch
```

The file is **automatically imported** by `home.nix`!

### Adding Keybinding Support

If your app needs custom keybindings:

1. **Define keybindings in [local.nix](../home/keybindings/local.nix)**:

```nix
{
  myapp = {
    action1 = "ctrl+k";
    action2 = "ctrl+shift+k";
  };
}
```

2. **Create converter in [converters.nix](../home/keybindings/converters.nix)**:

```nix
{
  toMyApp = bindings: {
    action1 = translateKey bindings.action1;
    action2 = translateKey bindings.action2;
  };
}
```

3. **Use in your program config**:

```nix
let
  kb = import ../../keybindings { inherit lib; };
  keys = kb.toMyApp kb.myapp;
in {
  programs.myapp.keybindings = keys;
}
```

---

## Common Commands

### Rebuild System

```bash
# Full system rebuild
sudo nixos-rebuild switch --flake ~/HyprForge#$(hostname)

# Home Manager only (faster for user configs)
home-manager switch --flake ~/HyprForge#$(hostname)
```

### Package Management

```bash
# Search for packages
nix search nixpkgs <name>

# List installed packages (Home Manager)
home-manager packages

# Garbage collection (remove old generations)
nix-collect-garbage -d
sudo nix-collect-garbage -d
```

### Flake Operations

```bash
# Update all inputs (nixpkgs, home-manager, etc.)
nix flake update

# Update specific input
nix flake lock --update-input nixpkgs

# Show flake info
nix flake show
```

### Development Shells

```bash
# Enter dev shell
nix develop ~/HyprForge/share/dev-templates/python-ml

# Run command in shell
nix develop ~/HyprForge/share/dev-templates/rust --command cargo build
```

---

## Customization

### Changing Theme Colors

Edit [theme/theme.nix](../theme/theme.nix) - based on Catppuccin Mocha palette.

Most apps use the official Catppuccin modules automatically. This file is for apps without direct support.

### Changing Wallpapers

Add images to [share/wallpapers/](../share/wallpapers/):

```bash
cp ~/Pictures/mywallpaper.jpg ~/HyprForge/share/wallpapers/
homeswitch  # Copies to ~/Pictures/Wallpapers
```

Press `SUPER+SHIFT+W` to cycle through wallpapers.

### Modifying System Services

Edit [system/services.nix](../system/services.nix):

```nix
{
  # Enable/disable services
  services.printing.enable = true;
  services.bluetooth.enable = true;

  # Configure services
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
}
```

### Hardware Configuration

Edit [user.nix](../user.nix):

```nix
{
  username = "yourname";
  hostname = "your-machine";
  hasNvidiaGpu = true;  # Enable NVIDIA drivers

  # Printer drivers (empty list = no printing)
  printerDrivers = [ "epson-escpr2" ];

  # Swap configuration
  swapDevice = "/dev/disk/by-uuid/your-uuid";
  swapSizeGB = 8;
}
```

### Custom Scripts

Add scripts to [home/scripts/](../home/scripts/):

- `.sh` files → Automatically wrapped as shell scripts
- `.py` files → Automatically wrapped as Python scripts

They're auto-installed and available in `$PATH`!

---

## Suggested Shell Aliases

Add these to your shell config for convenience:

```bash
# Rebuild shortcuts
alias sysswitch='sudo nixos-rebuild switch --flake ~/HyprForge#$(hostname)'
alias homeswitch='home-manager switch --flake ~/HyprForge#$(hostname)'

# Quick edits
alias editnix='cd ~/HyprForge && code .'
alias editpkgs='code ~/HyprForge/home/packages.nix'
alias editkeys='code ~/HyprForge/home/keybindings/local.nix'

# Cleanup
alias nixclean='nix-collect-garbage -d && sudo nix-collect-garbage -d'
```

---

## Tips

1. **Test changes safely** - NixOS keeps old generations, you can always rollback
2. **Use comments** - Document why you installed packages
3. **Keep packages.nix organized** - Use the category structure provided
4. **Update regularly** - `nix flake update` keeps packages current
5. **Backup user.nix** - It contains your machine-specific settings

---

For more details:

- [Architecture Documentation](ARCHITECTURE.md) - How the system works internally
- [Keybindings Reference](KEYBINDINGS.md) - Complete keybinding list
- [Package List](PACKAGES.md) - All available packages
- [FAQ](FAQ.md) - Common questions
