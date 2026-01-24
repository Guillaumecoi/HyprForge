# Central environment configuration
# This file manages XDG directories and imports environment modules.
# Environment variables and app defaults are defined in ./environment/

{ config
, pkgs
, lib
, ...
}:

let
  # Import environment configuration
  envConfig = import ./environment { inherit config pkgs lib; };

  # Additional non-standard XDG directories to create
  extraXdgDirs = [
    "$HOME/Projects"
    "$HOME/Dev-Environments"
  ];

in
{
  # Import environment configuration (apps, core env vars, waybar/weather)
  imports = [ ./environment ];
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

  # Configure zsh to use XDG-compliant directory
  # Using XDG config directory for dotfiles and XDG data for history
  programs.zsh = {
    dotDir = "${config.xdg.configHome}/zsh";
    history = {
      path = "${config.xdg.dataHome}/zsh/history";
      size = 10000;
      save = 10000;
    };
  };

  # Ensure zsh config directory exists
  home.activation.createZshDir = lib.hm.dag.entryBefore ["writeBoundary"] ''
    mkdir -p "$HOME/.config/zsh"
    mkdir -p "$HOME/.local/share/zsh"
  '';
}
