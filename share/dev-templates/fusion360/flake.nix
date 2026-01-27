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
        pkgs = nixpkgs.legacyPackages.${system};
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
            echo "This environment provides Wine and dependencies for running Fusion 360 on Linux"
            echo ""
            echo "Installation steps:"
            echo "1. Download the installer script:"
            echo "   curl -L https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/setup/autodesk_fusion_installer_x86-64.sh -o installer.sh"
            echo ""
            echo "2. Make it executable:"
            echo "   chmod +x installer.sh"
            echo ""
            echo "3. Run the installer (basic):"
            echo "   ./installer.sh --install --default"
            echo ""
            echo "4. Or run with all extensions:"
            echo "   ./installer.sh --install --default --full"
            echo ""
            echo "System Requirements:"
            echo "  - 4+ GB RAM (6+ GB recommended)"
            echo "  - 3 GB disk space"
            echo "  - DirectX11 capable GPU (1+ GB VRAM)"
            echo "  - Active Fusion 360 license required"
            echo ""
            echo "For more information: https://github.com/cryinkfly/Autodesk-Fusion-360-for-Linux"
            echo ""

            export PROJECT_ROOT=$PWD
            export WINEPREFIX="$PWD/.wine"
            export WINEARCH=win64
            export WINEDLLOVERRIDES="mscoree,mshtml="

            # Set up Wine prefix if it doesn't exist
            if [ ! -d "$WINEPREFIX" ]; then
              echo "Creating Wine prefix at $WINEPREFIX..."
              wineboot -u
            fi

            echo "Wine prefix: $WINEPREFIX"
            echo "Wine version: $(wine --version)"
          '';
        };
      }
    );
}
