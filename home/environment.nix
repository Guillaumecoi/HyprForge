# Central environment configuration
# This file consolidates all environment variables and settings used across the system.
# Default applications are defined in keybindings/apps.nix.

{
  config,
  pkgs,
  lib,
  ...
}:

let
  # Import default applications
  apps = import ./apps.nix;

  # Environment variables for default applications
  envVars = {
    TERMINAL = apps.terminal;
    EDITOR = apps.editor; # CLI editor for shell
    VISUAL = apps.editorAlt; # GUI editor
    BROWSER = apps.browser;
    BROWSER_ALT = apps.browserAlt;
    EXPLORER = apps.explorer;
    EXPLORER_ALT = apps.explorerAlt;
    NOTES = apps.notes;
    AI_CLI = apps.aiCli;
  };

  # Theme/appearance settings
  theme = {
    GTK_THEME = "catppuccin-mocha-mauve-standard";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORMTHEME = "kvantum";
    COLOR_SCHEME = "prefer-dark";
    GTK_APPLICATION_PREFER_DARK_THEME = "1";
    # Use the exact installed cursor theme directory name
    XCURSOR_THEME = "Bibata-Modern-Classic";
    XCURSOR_SIZE = "24";
  };

  # Weather configuration (used by scripts/waybar)
  weather = {
    WEATHER_LANG = "en";
    WEATHER_TEMPERATURE_UNIT = "c";
    WEATHER_TIME_FORMAT = "24h";
    WEATHER_WINDSPEED_UNIT = "km/h";
    WEATHER_SHOW_ICON = "True";
    WEATHER_SHOW_LOCATION = "False";
    WEATHER_SHOW_TODAY_DETAILS = "True";
    WEATHER_FORECAST_DAYS = "3";
    WEATHER_LOCATION = "";
  };

  # Merge all environment variables
  allEnvVars = weather // envVars // theme;

  # Generate .env file content for scripts
  envFileContent =
    lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "${name}=${value}") allEnvVars) + "\n";

  # Write a minimal PAM environment file with only the cursor variables so
  # display managers/PAM will pick them up before the compositor starts.
  pamEnvContent =
    lib.concatStringsSep "\n" [
      "XCURSOR_THEME=Bibata-Modern-Classic"
      "XCURSOR_SIZE=24"
    ]
    + "\n";

  # Additional non-standard XDG directories to create
  extraXdgDirs = [
    "$HOME/Projects"
    "$HOME/Dev-Environments"
  ];

in
{
  # Export session variables (available to all programs)
  home.sessionVariables = lib.mkForce allEnvVars;

  # Create .env file for scripts that source it
  home.file."scripts/.env".text = envFileContent;

  # Ensure display manager / PAM sessions get the cursor variables early.
  home.file.".pam_environment".text = pamEnvContent;

  # Fallback for icon/cursor theme selection: create ~/.icons/default/index.theme
  # so GTK/Wayland clients inherit the Bibata cursor even if env vars aren't applied.
  home.file.".icons/default/index.theme".text = ''
    [Icon Theme]
    Inherits=Bibata-Modern-Classic
  '';

  # Also provide a systemd-style environment file so sessions started via
  # systemd (or systemd-user) receive the cursor variables early.
  home.file.".config/environment.d/10-cursor.conf".text = ''
    XCURSOR_THEME=Bibata-Modern-Classic
    XCURSOR_SIZE=24
  '';
  # XDG base directories (managed by home-manager)
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      publicShare = "$HOME/Public";
      videos = "$HOME/Videos";
      templates = "$HOME/Templates";
    };
  };

  # Create non-standard XDG dirs during activation so they exist as
  # empty directories rather than containing placeholder files.
  home.activation.createProjectsAndEnvs = ''
    mkdir -p ${lib.concatStringsSep " " extraXdgDirs}
  '';

  # Keep current zsh dotfiles location (legacy behavior) to silence warning
  programs.zsh = {
    dotDir = config.home.homeDirectory;
  };
}
