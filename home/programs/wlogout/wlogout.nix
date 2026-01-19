# home/wlogout.nix
{
  lib,
  pkgs,
  pkgs-unstable,
  theme,
  ...
}:

let
  styleStr = builtins.readFile ./style.css;
in
{
  programs.wlogout = {
    # Provide the layout as a Nix list of attribute sets (required by the module)
    layout = [
      {
        label = "lock";
        action = "hyprlock";
        text = "Lock";
        keybind = "l";
      }
      {
        label = "logout";
        action = "hyprctl dispatch exit";
        text = "Logout";
        keybind = "e";
      }
      {
        label = "suspend";
        action = "systemctl suspend";
        text = "Suspend";
        keybind = "u";
      }
      {
        label = "shutdown";
        action = "systemctl poweroff";
        text = "Shutdown";
        keybind = "s";
      }
      {
        label = "hibernate";
        action = "systemctl hibernate";
        text = "Hibernate";
        keybind = "h";
      }
      {
        label = "reboot";
        action = "systemctl reboot";
        text = "Reboot";
        keybind = "r";
      }
    ];

    style = lib.mkForce styleStr;
  };

  # mount custom icons directory
  home.file.".config/wlogout/icons" = {
    source = ./icons;
    recursive = true;
  };

  # Install Catppuccin CSS so `@import "catppuccin.css"` works from style files
  home.file.".config/wlogout/catppuccin.css" = {
    source = ./catppuccin.css;
  };
}
