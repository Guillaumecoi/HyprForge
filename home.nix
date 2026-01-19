{
  config,
  lib,
  pkgs,
  pkgs-unstable,
  theme,
  ...
}:

let
  user = import ./user.nix;

  # Automatically import all program modules from ./home/programs
  # Each program directory contains a .nix file with the same name (e.g. programs/git/git.nix)
  programEntries = builtins.attrNames (builtins.readDir ./home/programs);
  programDirs = builtins.filter (
    name:
    let
      entry = builtins.readDir ./home/programs;
    in
    entry.${name} == "directory"
  ) programEntries;
  programImports = map (dir: ./home/programs/${dir}/${dir}.nix) programDirs;

  # Import unified package list
  packageList = import ./home/packages.nix { inherit pkgs pkgs-unstable; };

  # Load lists of known Home Manager modules from local JSON files
  # Update these lists by running: ./home/local-scripts/update-hm-programs.sh
  knownHmPrograms = builtins.fromJSON (builtins.readFile ./home/hm-programs.json);
  knownHmServices = builtins.fromJSON (builtins.readFile ./home/hm-services.json);
  knownHmMisc = builtins.fromJSON (builtins.readFile ./home/hm-misc.json);

  # Helper to resolve nested package paths like "nodePackages.prettier"
  getPackage =
    name:
    let
      parts = lib.splitString "." name;
      resolve =
        attrs: path:
        if path == [ ] then attrs else resolve (attrs.${builtins.head path}) (builtins.tail path);
    in
    resolve pkgs parts;

  # Check if a package name (or its base) is in the known HM modules lists
  hasHmModule =
    name:
    let
      baseName = builtins.head (lib.splitString "." name);
    in
    builtins.elem baseName knownHmPrograms
    || builtins.elem baseName knownHmServices
    || builtins.elem baseName knownHmMisc;

  # Split packages by category
  hmProgramModules = builtins.filter (
    p: builtins.elem (builtins.head (lib.splitString "." p)) knownHmPrograms
  ) packageList;
  hmServiceModules = builtins.filter (
    p: builtins.elem (builtins.head (lib.splitString "." p)) knownHmServices
  ) packageList;
  barePackages = builtins.filter (p: !(hasHmModule p)) packageList;
in

{
  imports = [
    ./home/scripts.nix
    ./home/environment.nix
    ./home/theme.nix
  ]
  ++ programImports;

  home.username = user.username;
  home.homeDirectory = "/home/${user.username}";
  home.stateVersion = "25.11";

  # Install remaining programs as bare packages
  home.packages = map getPackage barePackages;

  # Auto-enable programs that have HM modules
  programs = builtins.listToAttrs (
    map (name: {
      name = name;
      value = {
        enable = true;
      };
    }) hmProgramModules
  );

  # Auto-enable services that have HM modules
  services = builtins.listToAttrs (
    map (name: {
      name = name;
      value = {
        enable = true;
      };
    }) hmServiceModules
  );

  # Copy files to their appropriate locations, overwriting existing ones
  home.file.".local/share/emoji/emoji.db".source = ./share/emoji/emoji.db;
  home.file.".local/share/emoji/glyph.db".source = ./share/emoji/glyph.db;

  # Link individual files inside the folders to Nix, ensuring they are managed by Nix
  home.file."Templates/dev-templates" = {
    source = ./share/dev-templates;
    recursive = true;
  };
  home.file."Pictures/Wallpapers" = {
    source = ./share/wallpapers;
    recursive = true;
  };
}
