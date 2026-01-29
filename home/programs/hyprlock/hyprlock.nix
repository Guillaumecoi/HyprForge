{ pkgs, ... }:

{
  # Configure hyprlock using Home Manager's built-in module
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };

      animations = {
        enabled = true;
        fade_in = {
          duration = 300;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 300;
          bezier = "easeOutQuint";
        };
      };

      background = [
        {
          path = "~/Pictures/Wallpapers/nix/sakura-gate.jpg";
          blur_passes = 1;
          blur_size = 2;
        }
      ];
    };
  };
}
