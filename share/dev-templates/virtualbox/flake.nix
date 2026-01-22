{
  description = "VirtualBox VM Development Environment";

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
            virtualbox

            # Basic utilities
            wget
            curl

            # Optional: Additional VM tools
            # vagrant
            # packer

            # Optional: Remote access
            # freerdp  # RDP client
            # tigervnc  # VNC client
          ];

          shellHook = ''
            echo "📦 VirtualBox environment loaded"
            export PROJECT_ROOT=$PWD
          '';
        };
      }
    );
}
