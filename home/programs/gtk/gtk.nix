{ pkgs, lib, ... }:

{
  # GTK Theme Configuration
  gtk = {
    enable = true;

    theme = {
      # Use Catppuccin Mocha as the primary GTK theme
      name = "catppuccin-mocha-mauve-standard";
      package = pkgs.catppuccin-gtk.override {
        accents = [ "mauve" ];
        size = "standard";
        variant = "mocha";
      };
    };

    iconTheme = {
      # Use mkDefault so catppuccin module can override with catppuccin-papirus-folders
      name = lib.mkDefault "Papirus-Dark";
      package = lib.mkDefault pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 24;
    };

    # Enable dark theme preference for all GTK apps
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };

    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # Tell libadwaita applications to prefer the dark theme.
  # This uses dconf, a configuration system for GNOME apps.
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      "color-scheme" = "prefer-dark";
      "gtk-theme" = "catppuccin-mocha-mauve-standard";
      "icon-theme" = "Papirus-Dark";
      "cursor-theme" = "Bibata-Modern-Classic";
      "cursor-size" = 24;
    };

    # Force dark mode for legacy GTK3 apps and window manager
    "org/gnome/desktop/wm/preferences" = {
      "theme" = "catppuccin-mocha-mauve-standard";
    };

    # Ensure file managers use dark theme
    "org/gtk/settings/file-chooser" = {
      "sort-directories-first" = true;
    };
  };

  # Qt application theming with Catppuccin Kvantum
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
  };

  # Configure Kvantum to use Catppuccin theme
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=catppuccin-mocha-mauve
  '';
}
