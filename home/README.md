# Home Manager Configuration

User-level configuration for packages, programs, and environment.

## Structure

- **packages.nix** - User packages by category
- **environment.nix** - Environment variables, XDG directories
- **scripts.nix** - Auto-wraps scripts from `scripts/`
- **keybindings/** - Central keybinding system
- **programs/** - Per-app configs (auto-imported)

## Keybindings

Central system in `keybindings/`:

- **default.nix** - Main entry, exports converters and keybindings
- **local.nix** - App keybindings (CTRL, ALT)
- **global.nix** - WM keybindings (SUPER)
- **apps.nix** - Default applications
- **converters.nix** - Format converters (Kitty, Yazi, Neovim, VSCode, etc.)

**Usage in programs:**

```nix
let
  kb = import ../../keybindings { inherit lib; };
  keys = kb.toKitty kb.tabs;  # Convert to Kitty format
in {
  programs.kitty.keybindings = {
    "${keys.new}" = "new_tab";
    "${keys.close}" = "close_tab";
  };
}
```

## Adding Programs

1. Create `programs/newapp/newapp.nix`
2. Import keybindings: `kb = import ../../keybindings { inherit lib; }`
3. Use converted keys: `keys = kb.toApp kb.category;`
4. Rebuild: `homeswitch`

Auto-imported by `home.nix`.

## Keybinding Philosophy

- **SUPER** - Window manager (Hyprland)
- **CTRL** - App actions (tabs, editing)
- **ALT** - Quick access (tab numbers)
- **Vim keys** - Navigation in TUI apps
