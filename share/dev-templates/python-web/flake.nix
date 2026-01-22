{
  description = "Python Web Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python
            python3Packages.pip
            python3Packages.virtualenv

            # Optional: Web frameworks
            # python3Packages.flask
            # python3Packages.django
            # python3Packages.fastapi
            # python3Packages.jinja2

            # Optional: HTTP and async
            # python3Packages.requests
            # python3Packages.aiohttp
            # python3Packages.websockets

            # Optional: Database drivers
            # python3Packages.sqlalchemy
            # python3Packages.psycopg2
            # python3Packages.redis
            # python3Packages.pymongo

            # Optional: Web scraping
            # python3Packages.beautifulsoup4
            # python3Packages.lxml

            # Optional: Development tools
            # python3Packages.black
            # python3Packages.flake8
            # python3Packages.pytest
            # python3Packages.rich
            # python3Packages.click

            # Optional: Data formats
            # python3Packages.pyyaml
            # python3Packages.toml

            # Optional: System tools (databases)
            # postgresql
            # redis
          ];

          shellHook = ''
            echo "🌐 Python Web environment loaded"
            export PROJECT_ROOT=$PWD

            if [ ! -d ".venv" ]; then
              python -m venv .venv
            fi
            source .venv/bin/activate
          '';
        };
      });
}
