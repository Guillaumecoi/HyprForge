{ config
, pkgs
, lib
, ...
}:

{
  # Enable rofi with Wayland support
  programs.rofi = {
    package = pkgs.rofi;
    enable = true;

    extraConfig = {
      icon-theme = "Oranchelo";
      show-icons = true;
      terminal = "kitty";
      drun-display-format = "{icon} {name}";
      location = 0;
      disable-history = false;
      hide-scrollbar = true;
      sidebar-mode = false;
    };

    theme = lib.mkForce ./cattpucchin-mocha.rasi;
  };
}
