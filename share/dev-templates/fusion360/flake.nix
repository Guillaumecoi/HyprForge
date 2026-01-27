{
  description = "Autodesk Fusion 360 for Linux Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Wine and dependencies for running Fusion 360
            wine
            wine64
            winetricks
            wineWowPackages.stable

            # Compression tools
            p7zip
            unzip
            cabextract

            # Network tools
            curl
            wget

            # SSL/TLS support
            openssl

            # Samba/Winbind for Windows networking
            samba

            # Display and graphics
            mesa
            vulkan-tools
            vulkan-loader

            # DXVK for DirectX to Vulkan translation
            dxvk

            # Additional Wine dependencies
            wine-staging

            # GUI dialog tools (for installation wizard)
            yad
            zenity

            # Optional: GPU drivers (uncomment based on your hardware)
            # For NVIDIA:
            linuxPackages.nvidia_x11

            # For AMD:
            # mesa-drivers

            # For Intel:
            # mesa-drivers

            # Development and debugging tools
            # git
            # bash
            # coreutils

            # Optional: 3D input devices support
            # libspnav  # For 3Dconnexion SpaceMouse
          ];

          shellHook = ''
            echo "🍷 Autodesk Fusion 360 for Linux environment loaded"
            echo ""
            echo "Wine version: $(wine --version)"
            echo "Wine prefix: $PWD/.wine"
            echo ""

            export PROJECT_ROOT=$PWD
            export WINEPREFIX="$PWD/.wine"
            export WINEARCH=win64
            export WINEDLLOVERRIDES="mscoree,mshtml="

            if [ ! -f ".fusion360-installed" ]; then
              echo "⚠️  Fusion 360 not yet installed!"
              echo "Run: ./install.sh"
              echo ""
            fi
