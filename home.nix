{ config
, lib
, pkgs
, pkgs-unstable
, theme
, ...
}:

let
  user = import ./user.nix;

  # Automatically import all program modules from ./home/programs
  # Each program directory contains a .nix file with the same name (e.g. programs/git/git.nix)
  programEntries = builtins.attrNames (builtins.readDir ./home/programs);
  programDirs = builtins.filter
    (
      name:
      let
        entry = builtins.readDir ./home/programs;
      in
      entry.${name} == "directory"
    )
    programEntries;
  programImports = map (dir: ./home/programs/${dir}/${dir}.nix) programDirs;
in

{
  imports = [
    ./home/scripts.nix
    ./home/environment.nix
    ./home/theme.nix
    ./theme/xdg.nix
    ./home/package-manager/package-manager.nix
  ]
  ++ programImports;

  home.username = user.username;
  home.homeDirectory = "/home/${user.username}";
  home.stateVersion = "25.11";

  # Copy files to their appropriate locations, overwriting existing ones
  home.file.".local/share/emoji/emoji.db".source = ./share/emoji/emoji.db;
  home.file.".local/share/emoji/glyph.db".source = ./share/emoji/glyph.db;

  home.file."Pictures/Wallpapers/nix".source = ./share/wallpapers;
  home.file."Templates/dev-templates/nix".source = ./share/dev-templates;
}
