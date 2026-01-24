# Home Manager Configuration

User-level configuration for packages, programs, and environment.

## Machine-Specific Files (Gitignored)

These files are unique to each user/machine and must be created locally:

### `home-config.nix` ⚙️

**Your personal settings**

- Git username and email
- Monitor configuration (resolution, position, scaling)
- Other user-specific preferences

Copy from example: `cp home-config.nix.example home-config.nix`

### `packages.nix` 📦

**Your software selection**

- List of all programs you want installed
- Customize this to add/remove software
- Commented examples included

Copy from example: `cp packages.nix.example packages.nix`

**After creating/editing these files, you must add them to git:**

```bash
git add -f home-config.nix packages.nix
```

This is required for Nix flakes to see them (they won't be committed due to .gitignore).

## Structure

- **home-config.nix** - Personal user settings (gitignored)
- **packages.nix** - User packages by category (gitignored)
- \*_environment/_ - Environment variables, XDG directories
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
