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
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python
            python3Packages.pip
            python3Packages.virtualenv
            
            # Web frameworks
            python3Packages.flask
            python3Packages.django
            python3Packages.fastapi
            python3Packages.jinja2
            
            # HTTP and async
            python3Packages.requests
            python3Packages.aiohttp
            python3Packages.websockets
            
            # Database
            python3Packages.sqlalchemy
            python3Packages.psycopg2
            python3Packages.redis
            python3Packages.pymongo
            
            # Web scraping and parsing
            python3Packages.beautifulsoup4
            python3Packages.lxml
            
            # Development tools
            python3Packages.black
            python3Packages.flake8
            python3Packages.pytest
            python3Packages.rich
            python3Packages.click
            
            # Data formats
            python3Packages.pyyaml
            python3Packages.toml
            
            # System tools
            postgresql  # Local database for development
            redis       # Local cache/session store
          ];
          
          shellHook = ''
            echo "🌐 Python Web environment loaded"
            echo "Python: $(python --version)"
            echo "Available frameworks: Flask, Django, FastAPI"
            echo "Databases: PostgreSQL, Redis, MongoDB"
            export PROJECT_ROOT=$PWD
            
            # Create virtual environment if it doesn't exist
            if [ ! -d ".venv" ]; then
              echo "Creating virtual environment..."
              python -m venv .venv
            fi
            
            # Activate virtual environment
            source .venv/bin/activate
            
            # Upgrade pip
            pip install --upgrade pip
            
            # Start local services if needed
            echo "💡 Run 'pg_ctl -D .postgres start' to start local PostgreSQL"
            echo "💡 Run 'redis-server' to start local Redis"
          '';
        };
      });
}