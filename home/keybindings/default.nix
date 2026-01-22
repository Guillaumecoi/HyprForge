# Central keybindings configuration
# Main entry point that exports converters, local (app) keybindings, and global (WM) keybindings
#
# CANONICAL FORMAT: "modifier+key" in lowercase
# Examples: "ctrl+t", "ctrl+shift+t", "alt+1", "shift+tab", "f11"
#
# PHILOSOPHY:
# - SUPER key: Window manager (Hyprland) - windows, workspaces (global.nix)
# - CTRL key: Application actions - tabs, editing, navigation (local.nix)
# - ALT key: Quick access - tab numbers, alternative actions (local.nix)
# - CTRL+ALT: System/AI actions (local.nix)
# - Vim keys (hjkl): Navigation in vim-enabled apps (local.nix)
{ lib ? import <nixpkgs/lib>
,
}:

let
  # Import components
  converters = import ./converters.nix { inherit lib; };
  local = import ./local.nix;

  # Import apps configuration from parent directory
  appsModule = import ../environment/apps.nix;
  apps = appsModule.apps;

  # Destructure converters for convenience
  inherit (converters)
    toKitty
    toYazi
    toNeovim
    toVscode
    toHyprland
    toFirefox
    ;

  # Helper function to convert all attributes in a category
  convertCategory = converter: category:
    if builtins.isAttrs category
    then builtins.mapAttrs (n: v: converter v) category
    else { };

  # Helper function to convert all categories for an app
  convertAllCategories = converter: localKeys:
    builtins.mapAttrs (categoryName: categoryKeys: convertCategory converter categoryKeys) localKeys;

in
{
  # Export apps configuration
  inherit apps;

  # Export converters
  inherit converters;

  # Export all local keybindings (canonical format) - automatically includes all categories
  inherit local;

  # Export individual categories for backward compatibility and convenience
  inherit (local)
    tabs
    terminalTabs
    windows
    panels
    navigation
    editing
    folding
    view
    ai
    help
    ;

  # Export global keybindings (for Hyprland)
  # Apps are imported from environment.nix and passed to global.nix
  global = import ./global.nix;

  # Pre-converted keybindings for each app - automatically includes ALL categories
  # Each app gets everything, uses what it needs
  kitty = convertAllCategories toKitty local;
  yazi = convertAllCategories toYazi local;
  neovim = convertAllCategories toNeovim local;
  vscode = convertAllCategories toVscode local;
  firefox = convertAllCategories toFirefox local;
}
