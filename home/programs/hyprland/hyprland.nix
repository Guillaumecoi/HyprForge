{ pkgs, pkgs-unstable, config, lib, ... }:

let
  # Import home config for monitor settings (fallback to example if not exists)
  homeConfigPath = ../../home-config.nix;
  homeConfigExample = ../../home-config.nix.example;
  homeConfig =
    if builtins.pathExists homeConfigPath
    then import homeConfigPath
    else import homeConfigExample;

  # Import central keybindings
  central = import ../../keybindings { inherit lib; };

  # Get global (WM-level) keybindings with apps from central config
  keybindings = central.global;

  # Import modular configuration files
  settings = import ./settings.nix;
  animations = import ./animations.nix;
  input = import ./input.nix;
  rules = import ./rules.nix;

  # Self-referencing: access our own config to generate a help script
  # Collect all bind* lists (bindd, bindde, binddel, binddl, binddm)
  keybinds =
    let s = config.wayland.windowManager.hyprland.settings;
    in pkgs.lib.concatLists [
      (if builtins.hasAttr "bindd" s then s.bindd else [ ])
      (if builtins.hasAttr "bindde" s then s.bindde else [ ])
      (if builtins.hasAttr "binddel" s then s.binddel else [ ])
      (if builtins.hasAttr "binddl" s then s.binddl else [ ])
      (if builtins.hasAttr "binddm" s then s.binddm else [ ])
    ];

  # Function to format each keybinding line for display
  format-keybind = bind:
    let
      # Split the line by comma
      parts = pkgs.lib.splitString "," bind;
      # Get the keys (first 2 parts)
      keys = pkgs.lib.concatStringsSep "," (pkgs.lib.take 2 parts);
      # Get the action (the rest)
      action = pkgs.lib.concatStringsSep "," (pkgs.lib.drop 2 parts);
    in
    # Replace variables and format for readability
    "<b>${pkgs.lib.replaceStrings [ "$mainMod" ] [ "SUPER" ] keys}</b>: ${action}";

  # Create the final list of formatted keybindings
  formatted-keybinds = pkgs.lib.map format-keybind keybinds;

  # Create executable script for keybind help
  keybinds-script = pkgs.writeShellScriptBin "hypr-keybinds" ''
    echo -e "${pkgs.lib.concatStringsSep "\\n" formatted-keybinds}" | rofi -dmenu -markup-rows -p "Hyprland Keybindings"
  '';

  # Create start-hyprland wrapper script
  # This is what the "Hyprland (Home Manager)" SDDM session executes
  start-hyprland-script = pkgs.writeShellScriptBin "start-hyprland" ''
    # Source environment variables
    if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
      . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    fi

    # Start Hyprland with Home Manager configuration
    exec ${pkgs-unstable.hyprland}/bin/Hyprland
  '';

in
{
  # Hyprland window manager configuration
  wayland.windowManager.hyprland = {
    enable = true;
    package = pkgs-unstable.hyprland;

    # Merge all imported configurations with monitor settings from home-config.nix
    settings = keybindings // settings // animations // input // rules // {
      monitor = homeConfig.monitors;
    };
  };

  # Add helper scripts to user packages
  home.packages = [
    keybinds-script
    start-hyprland-script  # Makes start-hyprland command available
  ];

  # Enable Catppuccin theming for Hyprland
  catppuccin.hyprland.enable = true;
}
