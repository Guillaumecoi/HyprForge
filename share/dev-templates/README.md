# Development Environment Templates

Isolated, project-specific development environments using Nix flakes. Each template provides a complete toolchain without polluting your system packages.

## Available Templates

| Template | Description | Included Tools |
|----------|-------------|----------------|
| **python-ml/** | Machine Learning & Data Science | NumPy, Pandas, Scikit-learn, Matplotlib, Jupyter |
| **python-web/** | Web Development | Flask, FastAPI, SQLAlchemy, Requests |
| **rust/** | Rust Development | Cargo, rustc, rust-analyzer, clippy |
| **cpp/** | C++ Development | GCC, CMake, GDB, Valgrind |
| **nodejs/** | Node.js Development | Node, npm, TypeScript, ESLint |
| **java/** | Java Development | JDK, Maven, Gradle |
| **pentesting/** | Security Testing | Nmap, Metasploit, Burp Suite, Wireshark |
| **cad-hardware/** | CAD & Hardware Design | KiCad, OpenSCAD, FreeCAD |

## Quick Start

### Method 1: Using direnv (Automatic activation)

1. Copy the template to your project:
```bash
cd ~/Projects/my-python-project
cp -r ~/HyprForge/share/dev-templates/python-ml/* .
```

2. Allow direnv to activate:
```bash
direnv allow
```

3. The environment activates automatically when you enter the directory!
```bash
cd ~/Projects/my-python-project  # Environment loads
python --version                  # Python with ML packages available
cd ~                              # Environment unloads
```

### Method 2: Manual activation

```bash
cd ~/Projects/my-rust-project
nix develop ~/HyprForge/share/dev-templates/rust
# Rust toolchain now available in this shell
cargo --version
```

### Method 3: One-time shell

Run a command in an isolated environment without entering the directory:
```bash
nix develop ~/HyprForge/share/dev-templates/python-ml --command python script.py
```

## Customizing Templates

Each template contains a `flake.nix` you can customize:

```nix
{
  description = "My Custom Python Environment";

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system};
      in {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            python3
            python3Packages.numpy
            # Add your packages here
            python3Packages.myCustomPackage
          ];
        };
      }
    );
}
```

## Using with direnv

HyprForge includes direnv by default. To enable automatic environment switching:

1. Copy a template to your project directory
2. Run `direnv allow` once
3. Every time you `cd` into the directory, the environment activates automatically
4. When you leave, it deactivates

## Benefits

✅ **No system pollution** - Tools exist only for this project
✅ **Reproducible** - Same versions on every machine
✅ **Isolated** - Different projects can use different tool versions
✅ **Automatic cleanup** - Delete project → tools gone
✅ **Team-friendly** - Share exact development environments via git

## Examples

### Python ML Project
```bash
cd ~/Projects/ml-experiment
cp -r ~/HyprForge/share/dev-templates/python-ml/* .
direnv allow

# Now you have Python + NumPy + Pandas + Jupyter
python -c "import numpy; print(numpy.__version__)"
jupyter notebook
```

### Rust Project
```bash
cd ~/Projects/my-cli-tool
cp -r ~/HyprForge/share/dev-templates/rust/* .
direnv allow

cargo new .
cargo build
```

### Web Development
```bash
cd ~/Projects/api-server
cp -r ~/HyprForge/share/dev-templates/python-web/* .
direnv allow

python app.py  # Flask/FastAPI ready
```

## Tips

- **Edit flake.nix** to add/remove packages for your specific needs
- **Commit flake.nix** to git so teammates get identical environments
- **Use flake.lock** to pin exact versions (run `nix flake update` to update)
- **Combine templates** - Copy multiple flakes and merge their buildInputs

## Troubleshooting

**"direnv: error .envrc is blocked"**
Run `direnv allow` in the project directory

**"Package not found"**
Search for packages: `nix search nixpkgs <package-name>`
Add to buildInputs in flake.nix

**"Old version of tool"**
Update the flake: `nix flake update`

## Creating Your Own Templates

1. Start with an existing template
2. Modify `buildInputs` list
3. Update the description
4. Save to `~/HyprForge/share/dev-templates/my-template/`
