# Package Manager Module
# Handles automatic package installation with Home Manager module detection
#
# This module:
# - Loads the unified package list from ../packages.nix
# - Detects which packages have Home Manager modules (programs.*, services.*)
# - Auto-enables HM modules for supported packages
# - Installs remaining packages as bare home.packages
# - Manages Flatpak installation and cleanup
#
# To update the HM module lists, run: ./update-hm-modules.sh

{ config, lib, pkgs, pkgs-unstable, ... }:

let
  # Import unified package list
  packages = import ../packages.nix { inherit pkgs pkgs-unstable; };
  packageList = packages.nixPackages;
  flatpakList = packages.flatpakPackages;

  # Load lists of known Home Manager modules from local JSON files
  knownHmPrograms = builtins.fromJSON (builtins.readFile ./hm-programs.json);
  knownHmServices = builtins.fromJSON (builtins.readFile ./hm-services.json);
  knownHmMisc = builtins.fromJSON (builtins.readFile ./hm-misc.json);

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
  hmProgramModules = builtins.filter
    (
      p: builtins.elem (builtins.head (lib.splitString "." p)) knownHmPrograms
    )
    packageList;
  hmServiceModules = builtins.filter
    (
      p: builtins.elem (builtins.head (lib.splitString "." p)) knownHmServices
    )
    packageList;
  barePackages = builtins.filter (p: !(hasHmModule p)) packageList;
in

{
  # Install remaining programs as bare packages
  home.packages = map getPackage barePackages;

  # Auto-enable programs that have HM modules
  programs = builtins.listToAttrs (
    map
      (name: {
        name = name;
        value = {
          enable = true;
        };
      })
      hmProgramModules
  );

  # Auto-enable services that have HM modules
  services = builtins.listToAttrs (
    map
      (name: {
        name = name;
        value = {
          enable = true;
        };
      })
      hmServiceModules
  );

  # Flatpak installation and cleanup from flatpakList
  home.activation.installFlatpaks = lib.hm.dag.entryAfter ["writeBoundary"] ''
    # Use full path to flatpak from Nix store
    FLATPAK="${pkgs.flatpak}/bin/flatpak"

    # Add Flathub remote if not already added
    if ! $FLATPAK remote-list --user 2>/dev/null | grep -q flathub; then
      echo "📦 Adding Flathub remote..."
      $FLATPAK remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo 2>/dev/null || true
    fi

    # Remove packages that are installed but not in the list
    UNINSTALLS=0
    INSTALLED_PACKAGES=$($FLATPAK list --user --app --columns=application 2>/dev/null || echo "")
    if [ -n "$INSTALLED_PACKAGES" ]; then
      while IFS= read -r installed_pkg; do
        SHOULD_KEEP=0
        ${lib.concatMapStringsSep "\n" (pkg: ''
          if [ "$installed_pkg" = "${pkg}" ]; then
            SHOULD_KEEP=1
          fi
        '') flatpakList}

        if [ $SHOULD_KEEP -eq 0 ]; then
          if [ $UNINSTALLS -eq 0 ]; then
            echo "🗑️  Removing Flatpak packages no longer in list..."
          fi
          echo "  Removing $installed_pkg..."
          $FLATPAK uninstall --user -y --noninteractive "$installed_pkg" >/dev/null 2>&1 || echo "  ⚠️  Failed to remove $installed_pkg"
          UNINSTALLS=$((UNINSTALLS + 1))
        fi
      done <<< "$INSTALLED_PACKAGES"
    fi

    if [ $UNINSTALLS -gt 0 ]; then
      echo "✅ Removed $UNINSTALLS Flatpak package(s)"
    fi

    ${if flatpakList != [] then ''
      # Install each package (only show output for new installations)
      NEW_INSTALLS=0
      ${lib.concatMapStringsSep "\n" (pkg: ''
        if ! $FLATPAK list --user 2>/dev/null | grep -q "${pkg}"; then
          if [ $NEW_INSTALLS -eq 0 ]; then
            echo "📦 Installing Flatpak packages..."
          fi
          echo "  Installing ${pkg}..."
          $FLATPAK install --user -y --noninteractive flathub "${pkg}" >/dev/null 2>&1 || echo "  ⚠️  Failed to install ${pkg}"
          NEW_INSTALLS=$((NEW_INSTALLS + 1))
        fi
      '') flatpakList}

      if [ $NEW_INSTALLS -gt 0 ]; then
        echo "✅ Installed $NEW_INSTALLS new Flatpak package(s)"
      fi
    '' else ""}
  '';
}
