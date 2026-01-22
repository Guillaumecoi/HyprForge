{
  description = "CAD and Hardware Development Environment";

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
            # PCB Design
            kicad
            # kicad-small # Lightweight version of KiCad

            # 3D CAD
            freecad
            openscad

            # Basic tools
            # gnumake # Build automation tool

            # Optional: Electronics simulation
            # ngspice

            # Optional: Arduino and embedded
            # arduino
            # arduino-cli
            # platformio
            # avrdude
            # esptool

            # Optional: 3D printing
            # prusa-slicer
            # cura

            # Optional: Python scripting
            # python3
            # python3Packages.pyserial
            # python3Packages.numpy
            # python3Packages.matplotlib

            # Optional: Documentation
            # pandoc
            # graphviz

            # Optional: File viewers
            # gerbv  # Gerber file viewer
            # git-lfs
            # cmake
          ];

          shellHook = ''
            echo "🔧 CAD/Hardware environment loaded"
            export PROJECT_ROOT=$PWD
          '';
        };
      }
    );
}
