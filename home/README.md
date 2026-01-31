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
- **environment/** - Environment variables, XDG directories, default apps
- **scripts/** - Custom utility scripts
- **keybindings/** - Central keybinding system
  - `default.nix` - Main entry point
  - `converters.nix` - Format converters for different apps
  - `global.nix` - Window manager keybindings (SUPER key)
  - `local.nix` - Application keybindings (CTRL/ALT)
- **programs/** - Per-app configs (auto-imported)
- **theme/** - Catppuccin theme configuration
- **package-manager/** - Package management tooling

## Keybindings

Central system in `keybindings/`:

- **default.nix** - Main entry, exports converters and keybindings
- **converters.nix** - Format converters (Kitty, Yazi, Neovim, VSCode, etc.)
- **global.nix** - WM keybindings (SUPER)
- **local.nix** - App keybindings (CTRL, ALT)

Default applications are defined in `environment/apps.nix`.

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
