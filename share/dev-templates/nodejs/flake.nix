{
  description = "Node.js Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            nodejs_22
            nodePackages.npm

            # Optional: Package managers
            # nodePackages.yarn
            # nodePackages.pnpm

            # Optional: TypeScript ecosystem
            # nodePackages.typescript
            # nodePackages.ts-node
            # nodePackages."@types/node"

            # Optional: Development tools
            # nodePackages.nodemon
            # nodePackages.eslint
            # nodePackages.prettier
            # nodePackages.vite

            # Optional: Testing
            # nodePackages.jest

            # Optional: Build tools
            # nodePackages.webpack
            # nodePackages.webpack-cli
          ];

          shellHook = ''
            echo "⚡ Node.js environment loaded"
            export PROJECT_ROOT=$PWD
          '';
        };
      });
}
