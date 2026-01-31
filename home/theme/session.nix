# XDG and theme-related environment variables and configurations
# Theme appearance settings, cursor theme, and related files
{ config, pkgs, lib, ... }:

let
  homeConfig = import ../home-config.nix;
  cursorTheme = homeConfig.cursor.theme;
  cursorSize = toString homeConfig.cursor.size;
  themeFlavor = homeConfig.theme.flavor;
  themeAccent = homeConfig.theme.accent;
in
{
  # Theme/appearance environment variables
  home.sessionVariables = {
    GTK_THEME = "catppuccin-${themeFlavor}-${themeAccent}-standard";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORMTHEME = "kvantum";
    COLOR_SCHEME = "prefer-dark";
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
    # Use the exact installed cursor theme directory name
    XCURSOR_THEME = cursorTheme;
    XCURSOR_SIZE = cursorSize;
  };

  # Write a minimal PAM environment file with only the cursor variables so
  # display managers/PAM will pick them up before the compositor starts.
  home.file.".pam_environment".text = ''
    XCURSOR_THEME=${cursorTheme}
    XCURSOR_SIZE=${cursorSize}
  '';

  # Fallback for icon/cursor theme selection: create ~/.icons/default/index.theme
  # so GTK/Wayland clients inherit the Bibata cursor even if env vars aren't applied.
  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Inherits=${cursorTheme}
  '';

  # Also provide a systemd-style environment file so sessions started via
  # systemd (or systemd-user) receive the cursor variables early.
  home.file.".config/environment.d/10-cursor.conf".text = ''
    XCURSOR_THEME=${cursorTheme}
    XCURSOR_SIZE=${cursorSize}
  '';
}
