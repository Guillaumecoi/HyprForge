{
  description = "Python ML Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python
            python3Packages.pip
            python3Packages.virtualenv

            # Optional: Core ML packages
            # python3Packages.numpy
            # python3Packages.scipy
            # python3Packages.pandas
            # python3Packages.scikit-learn
            # python3Packages.matplotlib
            # python3Packages.seaborn
            # python3Packages.plotly
            # python3Packages.jupyter
            # python3Packages.ipython

            # Optional: Computer vision
            # python3Packages.opencv4
            # python3Packages.pillow

            # Optional: Development tools
            # python3Packages.black
            # python3Packages.flake8
            # python3Packages.pytest
            # python3Packages.requests
            # python3Packages.tqdm

            # Optional: Data formats
            # python3Packages.pyyaml
            # python3Packages.h5py
            # python3Packages.openpyxl
          ];

          shellHook = ''
            echo "🐍 Python ML environment loaded"
            export PROJECT_ROOT=$PWD

            if [ ! -d ".venv" ]; then
              python -m venv .venv
            fi
            source .venv/bin/activate
          '';
        };
      });
}
