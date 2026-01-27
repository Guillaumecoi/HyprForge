# Development Environment Templates

Isolated, project-specific development environments using Nix flakes. Each template provides a complete toolchain without polluting your system packages.

## Quick Start

The `dev-init` command is automatically installed via home-manager and makes setting up development environments effortless.

### Initialize a Development Environment

```bash
cd ~/Projects/my-python-project
dev-init python-ml
```

This will:

1. Copy the template's `flake.nix` to your current directory
2. Prompt you to edit it for your project's needs
3. Create `.envrc` for automatic direnv activation
4. Run any optional installation scripts included in the template
5. Activate the environment

### List Available Templates

```bash
dev-init
# Shows all available templates
```

### Using the Environment

Once initialized, the environment activates automatically:

```bash
cd ~/Projects/my-python-project  # Environment loads
python --version                  # Python with ML packages available
cd ~                              # Environment unloads
```

## How It Works

### Template Structure

Each template in `share/dev-templates/<template-name>/` contains:

- **flake.nix** - Defines packages to install and environment setup

### Adding Custom Templates

1. Create a new directory in `share/dev-templates/`:

```bash
mkdir -p share/dev-templates/my-template
```

2. Add a `flake.nix`:

```nix
{
  # Short description of what this environment provides
  description = "My Custom Development Environment";

  # Input sources - where to get packages from
  inputs = {
    # Main package repository (use nixos-unstable for latest versions)
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Utility for supporting multiple systems (Linux, macOS, etc.)
    flake-utils.url = "github:numtide/flake-utils";

    # Add additional inputs here if needed (e.g., rust-overlay, poetry2nix)
    # example-overlay.url = "github:organization/repo";
  };

  # What this flake outputs (the actual development shell)
  outputs = {
    nixpkgs,
    flake-utils,
    # List any additional inputs here
    ...
  }:
    # Create shell for each supported system (x86_64-linux, aarch64-darwin, etc.)
    flake-utils.lib.eachDefaultSystem (system:
      let
        # Define any overlays here (modifications to nixpkgs)
        overlays = [
          # (import example-overlay)
        ];

        # Import packages with overlays applied
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        # Define any custom package configurations here
        # Example: customPython = pkgs.python3.withPackages (ps: with ps; [ numpy pandas ]);

      in {
        # The default development shell
        devShells.default = pkgs.mkShell {
          # Packages to install in this environment
          buildInputs = with pkgs; [
            # Core tools (always enabled)
            python3
            python3Packages.numpy
            git

            # Optional tools (uncomment as needed)
            # python3Packages.pandas
            # python3Packages.matplotlib
            # nodejs
            # cargo
          ];

          # Commands to run when entering the shell
          shellHook = ''
            echo "🚀 Development environment loaded"
          '';
        };
      }
    );
}
```

**Flake Structure Explained:**

- **description**: Brief description of the environment (shown in `nix flake info`)
- **inputs**: External dependencies
  - `nixpkgs`: The main package repository (use `nixos-unstable` for latest packages)
  - `flake-utils`: Helper for multi-system support
  - Add language-specific overlays here (e.g., `rust-overlay`, `poetry2nix`)
- **outputs**: What the flake provides
  - `eachDefaultSystem`: Ensures it works on Linux, macOS, etc.
  - **overlays**: Modifications or extensions to nixpkgs (usually empty)
  - **pkgs**: The package set to use
  - **buildInputs**: List of packages to install (core tools + optional tools)
  - **shellHook**: Bash script that runs when entering the environment
    - Display welcome messages
    - Set environment variables
    - Create directories
    - Run initialization commands

3. (Optional) Add an `install.sh` script:

```bash
#!/usr/bin/env bash
# This runs after dev-init copies files
echo "Setting up project structure..."
mkdir -p src tests
echo "print('Hello')" > src/main.py
```

4. Rebuild your system/home-manager config - the template is now available via `dev-init my-template`

## Benefits

✅ **Minimal by default** - Core tools included, extras commented out
✅ **No system pollution** - Tools exist only for this project
✅ **Reproducible** - Same versions on every machine
✅ **Isolated** - Different projects can use different tool versions
✅ **Automatic cleanup** - Delete project → tools gone
✅ **Team-friendly** - Share exact development environments via git
✅ **Easy customization** - Uncomment optional tools as needed

## Examples

### Python ML Project

```bash
cd ~/Projects/ml-experiment
dev-init python-ml

# Now you have Python + NumPy + Pandas + Jupyter
python -c "import numpy; print(numpy.__version__)"
jupyter notebook
```

### Rust Project

```bash
cd ~/Projects/my-cli-tool
dev-init rust

cargo new .
cargo build
```

### Web Development

```bash
cd ~/Projects/api-server
dev-init python-web

python app.py  # Flask/FastAPI ready
```

### Node.js Project

```bash
cd ~/Projects/web-app
dev-init nodejs

npm init -y
npm install express
```

### Autodesk Fusion 360 for Linux

```bash
cd ~/Projects/cad-projects
dev-init fusion360

# Download and run the installer
curl -L https://raw.githubusercontent.com/cryinkfly/Autodesk-Fusion-360-for-Linux/main/files/setup/autodesk_fusion_installer_x86-64.sh -o installer.sh
chmod +x installer.sh

# Basic installation
./installer.sh --install --default

# Or with all extensions
./installer.sh --install --default --full
```

### VirtualBox VMs

```bash
cd ~/Projects/vms
dev-init virtualbox

# If template includes download-os.sh script:
./download-os.sh  # Download Ubuntu, NixOS, Debian, etc.
VBoxManage createvm --name "MyVM" --register
```

### QEMU VMs

```bash
cd ~/Projects/qemu-vms
dev-init qemu

# If template includes download-os.sh script:
./download-os.sh  # Download OS images
qemu-img create -f qcow2 disk.qcow2 20G
qemu-system-x86_64 -cdrom iso/ubuntu.iso -hda disk.qcow2 -m 4G
```

**Finding Packages:**

```bash
# Search for packages
nix search nixpkgs python

# Search for Python packages specifically
nix search nixpkgs python3Packages.numpy
```

### Shell Hooks

The `shellHook` runs when entering the environment:

```nix
shellHook = ''
  echo "🚀 Environment loaded"

  # Set environment variables
  export DATABASE_URL="sqlite:///local.db"
  export DEBUG=1

  # Create project structure
  mkdir -p src tests docs

  # Display available commands
  echo "Available commands: python, npm, git"
'';
```

### Optional Setup Scripts

Templates can include an `install.sh` script that runs once during initialization:

```bash
#!/usr/bin/env bash
# Runs automatically after dev-init copies files
# Has access to all packages from buildInputs

echo "Initializing project..."

# Create directory structure
mkdir -p src tests docs .github/workflows

# Initialize git
git init
cat > .gitignore <<EOF
*.pyc
__pycache__/
.env
node_modules/
EOF

# Create starter files
echo "print('Hello, World!')" > src/main.py
echo "# My Project" > README.md

# Install dependencies
# pip install -r requirements.txt
# npm install

echo "✅ Project initialized!"
```

**Key differences:**

- **shellHook**: Runs every time you enter the directory (sets env vars, displays info)
- **install.sh**: Runs once during `dev-init` (creates files, initializes git, installs deps)

## Tips

- **Edit flake.nix** during `dev-init` to customize packages for your project
- **Commit flake.nix and .envrc** to git so teammates get identical environments
- **Use flake.lock** to pin exact versions (run `nix flake update` to update)
- **Add templates** to `share/dev-templates/` and rebuild to make them available system-wide
- **Installation scripts** are great for scaffolding project structure, initializing git, creating config files, etc.

## Troubleshooting

**"direnv: error .envrc is blocked"**
Run `direnv allow` in the project directory (dev-init should do this automatically)

**"Template not found"**
Run `dev-init` without arguments to see available templates. Templates must be in `$HOME/Templates/dev-templates/`

**"Package not found"**
Search for packages: `nix search nixpkgs <package-name>`
Add to buildInputs in flake.nix

**"Old version of tool"**
Update the flake: `nix flake update`
