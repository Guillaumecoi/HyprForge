{
  pkgs,
  pkgs-unstable,
  theme,
  ...
}:
{
  programs.waybar = {
    package = pkgs-unstable.waybar;
    style = builtins.readFile ./style.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        mode = "dock";
        exclusive = true;
        height = 16;
        spacing = 6;
        reload_style_on_change = true;

        # Include all module configurations from files (*.jsonc) in ./modules
        include =
          let
            moduleFiles = builtins.filter (f: builtins.match ".*\\.jsonc$" f != null) (
              builtins.attrNames (builtins.readDir ./modules)
            );
          in
          builtins.map (f: "modules/${f}") moduleFiles;

        modules-left = [
          "tray"
          "hyprland/workspaces"
        ];
        modules-center = [
          "mpris"
          "clock"
          "custom/weather"
        ];
        modules-right = [
          "idle_inhibitor"
          "network"
          "backlight"
          "pulseaudio"
          "cpu"
          "memory"
          "battery"
        ];
      };
    };
  };

  # Copy modules folder so waybar can include them
  home.file.".config/waybar/modules" = {
    source = ./modules;
    recursive = true;
  };

  # Copy menus folder so waybar can include menu XML files
  home.file.".config/waybar/menus" = {
    source = ./menus;
    recursive = true;
  };

  # Enable Catppuccin theming for Waybar
  catppuccin.waybar = {
    enable = true;
    mode = "createLink";
  };

  # Copy modules.css so style.css can import it
  home.file.".config/waybar/modules.css" = {
    source = ./modules.css;
  };
}
