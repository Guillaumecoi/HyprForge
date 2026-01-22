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

  # Keep current zsh dotfiles location (legacy behavior) to silence warning
  programs.zsh = {
    dotDir = config.home.homeDirectory;
  };
}
