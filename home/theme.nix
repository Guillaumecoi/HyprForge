# Theme packages and configuration
# This file contains theme-related packages that aren't automatically
# installed by the catppuccin module but are needed for full theme support.

{ pkgs, ... }:

{
  # Enable Catppuccin theme globally for all supported programs
  catppuccin = {
    enable = true;
    flavor = "mocha"; # mocha (dark), macchiato, frappe, latte (light)
    accent = "mauve"; # blue, flamingo, green, lavender, maroon, mauve, peach, pink, red, rosewater, sapphire, sky, teal, yellow
  };

  home.packages = with pkgs; [
    # KDE color schemes for KDE apps (Ark, KDE Connect, etc.)
    catppuccin-kde

    # GTK theme for GNOME apps (Nautilus, Thunar, etc.)
    (catppuccin-gtk.override {
      accents = [ "mauve" ];
      size = "standard";
      variant = "mocha";
    })

    # Qt theming with Kvantum (for Qt apps)
    libsForQt5.qtstyleplugin-kvantum # Qt5 Kvantum plugin
    qt6Packages.qtstyleplugin-kvantum # Qt6 Kvantum plugin
    catppuccin-kvantum # Catppuccin theme for Kvantum

    # Icon theme - catppuccin module provides catppuccin-papirus-folders
    # which already includes Papirus with catppuccin-colored folders

    # GNOME Tweaks for managing GNOME theme settings
    gnome-tweaks

    # Adwaita-style dark theme (fallback for libadwaita apps)
    adw-gtk3
  ];
}
