# Frequently Asked Questions

## General Questions

### What is HyprForge?

HyprForge is a complete NixOS configuration featuring Hyprland (tiling window manager), carefully curated applications, and a unique centralized keybinding system. It transforms a fresh NixOS install into a fully functional desktop environment in minutes.

### Why should I use this over a standard desktop environment?

**Traditional DEs (GNOME, KDE):**
- Bloated with unused features
- Hard to customize deeply
- Settings scattered everywhere
- Difficult to reproduce on new machines

**HyprForge:**
- Minimal, fast, exactly what you need
- Everything explicit in config files
- One command to replicate your entire setup
- Two files contain all your software

### Is this only for advanced users?

No! While NixOS has a learning curve, HyprForge makes it accessible:
- Pre-configured everything
- Clear documentation
- Simple two-file package management
- Automated installer

If you can edit a text file and run terminal commands, you can use this.

---

## Installation & Setup

### Can I use this on existing NixOS?

Yes! Clone the repo and run:
```bash
git clone https://github.com/GuillaumeCoi/HyprForge.git ~/HyprForge
cd ~/HyprForge
# Edit user.nix with your settings
sudo nixos-rebuild switch --flake .#YOUR_HOSTNAME
```

### Can I use this without NixOS?

No, this is specifically for NixOS. However, you can:
- Use the Home Manager configs on other Linux distros (requires adaptation)
- Steal individual program configs for your setup
- Use the keybinding system concept elsewhere

### What if I don't want Hyprland?

You can adapt this for other window managers, but Hyprland is deeply integrated. You'd need to:
- Replace [home/programs/hyprland/](../home/programs/hyprland/) configs
- Update keybindings in [home/keybindings/global.nix](../home/keybindings/global.nix)
- Modify [system/sddm.nix](../system/sddm.nix) for your display manager

It's significant work - consider trying Hyprland first!

### Do I need an NVIDIA GPU?

No. Set `hasNvidiaGpu = false` in [user.nix](../user.nix). The NVIDIA drivers are conditionally loaded.

### How much disk space do I need?

- Base NixOS install: ~5GB
- HyprForge with all packages: ~15-20GB
- With dev tools and templates: ~25-30GB

Plus space for your files, of course.

---

## Package Management

### Where are all the packages listed?

In just two files:
- **[home/packages.nix](../home/packages.nix)** - User applications (browsers, editors, media players)
- **[system/packages.nix](../system/packages.nix)** - System utilities (drivers, core tools)

That's it. Everything explicit. No hidden dependencies.

### How do I add/remove software?

Edit [home/packages.nix](../home/packages.nix):
```nix
[
  "firefox"
  "spotify"    # Add this line
  # "gimp"     # Comment out to remove
]
```

Then run: `home-manager switch --flake ~/HyprForge#$(hostname)`

### How do I find package names?

```bash
nix search nixpkgs <package-name>
```

Example:
```bash
nix search nixpkgs blender
nix search nixpkgs "video editor"
```

### What's this "Home Manager" thing?

Home Manager manages user-level configuration declaratively. HyprForge automatically:
- Detects if a package has a Home Manager module
- Enables it with `programs.<name>.enable = true`
- Applies default configs

You get the benefits without the complexity!

### Can I use different package versions?

Yes, but it requires overlays or pulling from different nixpkgs branches. For most users, the unstable channel provides recent versions.

For project-specific versions, use [dev templates](../share/dev-templates/README.md).

---

## Customization

### How do I change the theme?

Most apps use Catppuccin Mocha automatically via the catppuccin/nix modules. For unsupported apps, edit [theme/theme.nix](../theme/theme.nix).

To change to a different theme entirely:
- Replace Catppuccin modules in [flake.nix](../flake.nix)
- Update [theme/theme.nix](../theme/theme.nix) colors
- Adjust per-app configs in [home/programs/](../home/programs/)

### How do I change keybindings?

Edit [home/keybindings/local.nix](../home/keybindings/local.nix) for app shortcuts or [home/keybindings/global.nix](../home/keybindings/global.nix) for window manager shortcuts.

Run `homeswitch` and changes apply everywhere automatically!

See [USAGE.md](USAGE.md#keybindings-system) for details.

### Can I use a different terminal?

Yes! Edit [home/keybindings/apps.nix](../home/keybindings/apps.nix):
```nix
{
  terminal = "alacritty";  # or "wezterm", "foot", etc.
}
```

Add the terminal to [home/packages.nix](../home/packages.nix), then rebuild.

### How do I add my own scripts?

Drop `.sh` or `.py` files into [home/scripts/](../home/scripts/). They're automatically wrapped and added to `$PATH`.

Example:
```bash
echo '#!/bin/bash
echo "Hello World"' > ~/HyprForge/home/scripts/hello.sh

homeswitch
hello  # Your script is now available!
```

---

## Keybindings & Usage

### I keep forgetting the shortcuts!

Press `SUPER+F1` anytime to see all keybindings in a searchable menu!

For app-specific shortcuts, press `CTRL+F1` while focused on the app.

### What's the "SUPER" key?

The Windows key / Command key. It's the main modifier for window management actions in Hyprland.

### How do I open applications?

- `SUPER+A` - Application launcher (Rofi)
- `SUPER+T` - Terminal
- `SUPER+E` - File manager
- `SUPER+B` - Web browser

See [KEYBINDINGS.md](KEYBINDINGS.md) for the complete list.

### Can I use the mouse?

Yes! Hyprland works perfectly with a mouse. Keybindings are available for speed, not required.

---

## Development

### How do dev templates work?

Templates provide isolated environments. Example:
```bash
cd ~/Projects/my-python-project
nix develop ~/HyprForge/share/dev-templates/python-ml
# Now you have Python + NumPy + Jupyter etc.
```

When you exit the shell, those tools disappear. Zero system impact.

See [dev-templates/README.md](../share/dev-templates/README.md) for details.

### Can I have multiple Python versions?

Yes! Create different templates with different Python versions:
```nix
python39  # For project A
python311 # For project B
```

Or use per-project `flake.nix` files to specify versions.

### Do I need Docker?

Podman is included by default (Docker-compatible). It's rootless and more secure.

Enable Docker if needed by uncommenting in [configuration.nix](../configuration.nix):
```nix
virtualisation.docker.enable = true;
```

---

## Troubleshooting

### My changes aren't applying!

Make sure you ran the right rebuild command:
- System changes: `sudo nixos-rebuild switch --flake ~/HyprForge#$(hostname)`
- User changes: `home-manager switch --flake ~/HyprForge#$(hostname)`

### I broke something, how do I rollback?

NixOS keeps previous generations:
```bash
# List generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Rollback
sudo nixos-rebuild switch --rollback
```

At boot, you can also select previous generations from the bootloader.

### Application won't start

1. Check it's in [home/packages.nix](../home/packages.nix)
2. Rebuild: `homeswitch`
3. Check for errors: `journalctl -xe`

### Keybinding doesn't work

1. Verify it's defined in [home/keybindings/](../home/keybindings/)
2. Check no conflicts with other apps
3. Rebuild: `homeswitch`
4. Restart the application

### Screen is black after login

Usually NVIDIA driver issues:
- Ensure `hasNvidiaGpu = true` in [user.nix](../user.nix)
- Try TTY2 (CTRL+ALT+F2) and rebuild
- Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)

---

## Performance & Maintenance

### How often should I update?

```bash
# Update packages
nix flake update
sudo nixos-rebuild switch --flake ~/HyprForge#$(hostname)
```

Recommended: Monthly for stability, weekly if you want latest packages.

### How do I clean up old packages?

```bash
# Remove old generations and unused packages
nix-collect-garbage -d
sudo nix-collect-garbage -d

# Optimize Nix store
nix-store --optimize
```

### Why is disk usage so high?

NixOS keeps multiple system generations for rollback. Run garbage collection (above) to clean up.

Also check: `ncdu /nix/store` to see what's using space.

### Is this resource-heavy?

No! Hyprland is lightweight:
- ~300MB RAM idle (vs 1-2GB for GNOME/KDE)
- Fast compositor (GPU-accelerated)
- Only runs what you configure

---

## Philosophy & Design

### Why two files for packages?

**Transparency.** Traditional Linux:
- 800+ packages installed
- Can't remember what's needed
- Afraid to remove anything
- Mystery dependencies everywhere

**HyprForge:**
- Open [home/packages.nix](../home/packages.nix) - that's everything you have
- One line = one app
- Delete line = completely gone, no orphans

### What's the deal with the keybinding system?

Traditional problem: Want to change "new tab" from CTRL+T to CTRL+N?
- Edit Kitty config
- Edit Firefox shortcuts
- Edit VSCode settings
- Edit Neovim mappings
- Edit 5+ more files...

HyprForge: Change one line in [home/keybindings/local.nix](../home/keybindings/local.nix), auto-updates everywhere.

### Why NixOS specifically?

NixOS is the only Linux distro that makes entire systems reproducible:
- Declarative configuration
- Atomic upgrades/rollbacks
- No dependency hell
- Dev environments without system pollution

Perfect for this use case.

---

## Contributing & Forking

### Can I fork this for my own use?

Absolutely! MIT licensed. Fork it, customize it, make it yours.

### Should I keep my fork public or private?

**Public** if you want to:
- Share your setup
- Get feedback
- Help others learn

**Private** if your configs contain:
- Work-specific tools
- Proprietary software
- Personal information

### How do I keep my fork updated with upstream?

```bash
git remote add upstream https://github.com/GuillaumeCoi/HyprForge.git
git fetch upstream
git merge upstream/main
```

Or cherry-pick specific commits.

### Can I contribute back?

This is a personal configuration, but feel free to:
- Report bugs
- Suggest improvements
- Share your fork
- Help others in discussions

---

## Still Have Questions?

- Check [USAGE.md](USAGE.md) for detailed usage instructions
- Read [ARCHITECTURE.md](ARCHITECTURE.md) to understand how it works
- See [TROUBLESHOOTING.md](TROUBLESHOOTING.md) for common issues
- Open a GitHub issue for bugs or feature requests
