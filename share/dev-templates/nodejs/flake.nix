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
            nodejs_22     # Latest LTS Node.js
            nodePackages.npm
            nodePackages.yarn
            nodePackages.pnpm
            
            # TypeScript ecosystem
            nodePackages.typescript
            nodePackages.ts-node
            nodePackages."@types/node"
            
            # Development tools
            nodePackages.nodemon
            nodePackages.eslint
            nodePackages.prettier
            nodePackages.vite
            
            # Testing
            nodePackages.jest
            
            # Build tools
            nodePackages.webpack
            nodePackages.webpack-cli
          ];
          
          shellHook = ''
            echo "⚡ Node.js environment loaded"
            echo "Node: $(node --version)"
            echo "NPM: $(npm --version)"
            echo "Available: TypeScript, Vite, ESLint, Prettier, Jest"
            export PROJECT_ROOT=$PWD
            
            # Set npm cache to local directory
            export NPM_CONFIG_CACHE=$PWD/.npm-cache
            
            # Create package.json if it doesn't exist
            if [ ! -f "package.json" ]; then
              echo "💡 Run 'npm init' to create package.json"
            fi
            
            echo "📦 Package managers available: npm, yarn, pnpm"
          '';
        };
      });
}