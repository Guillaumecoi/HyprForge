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

            # 3D CAD
            freecad
            openscad

            # Electronics simulation
            ngspice

            # Arduino and embedded development
            arduino
            arduino-cli
            platformio

            # 3D printing
            prusa-slicer
            cura
            openscad

            # Circuit design
            # fritzing  # Can be added if available

            # Microcontroller tools
            avrdude
            esptool

            # Python for hardware scripting
            python3
            python3Packages.pyserial
            python3Packages.numpy
            python3Packages.matplotlib

            # Version control for hardware
            git
            git-lfs

            # Documentation
            pandoc
            graphviz

            # File viewers
            gerbv # Gerber file viewer

            # Additional tools
            gnumake
            cmake
          ];

          shellHook = ''
            echo "🔧 CAD/Hardware environment loaded"
            echo ""
            echo "🖥️  PCB Design: KiCad"
            echo "📐 3D CAD: FreeCAD, OpenSCAD"
            echo "🔌 Electronics: ngspice, qucs"
            echo "⚡ Arduino: arduino-cli, platformio, avrdude"
            echo "🖨️  3D Printing: PrusaSlicer, Cura"
            export PROJECT_ROOT=$PWD

            # Create common project directories
            mkdir -p pcb cad firmware docs

            # Set up Arduino CLI
            if [ ! -d "$HOME/.arduino15" ]; then
              echo "💡 Run 'arduino-cli core update-index' to initialize Arduino"
            fi

            echo ""
            echo "📁 Directories created: pcb/, cad/, firmware/, docs/"
            echo ""
            echo "💡 Quick starts:"
            echo "   KiCad:     kicad"
            echo "   FreeCAD:   freecad"
            echo "   OpenSCAD:  openscad"
            echo "   Arduino:   arduino-cli board list"
            echo "   PlatformIO: pio init"
            echo ""
            echo "🔗 Useful for: PCB design, 3D modeling, embedded systems, IoT"
          '';
        };
      }
    );
}
