{
  description = "Rust Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      rust-overlay,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [
            "rust-src"
            "rust-analyzer"
          ];
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            # Rust toolchain
            rustToolchain

            # Additional components
            cargo-watch # Auto-recompile on changes
            cargo-edit # cargo add, cargo rm, cargo upgrade
            cargo-outdated # Check for outdated dependencies
            cargo-audit # Security vulnerability scanner
            cargo-flamegraph # Profiling
            cargo-nextest # Better testing
            cargo-expand # Expand macros

            # Code coverage
            cargo-tarpaulin

            # Cross-compilation
            cargo-cross

            # Development tools
            bacon # Background rust code checker

            # System libraries (often needed for crates)
            pkg-config
            openssl
          ];

          shellHook = ''
            echo "🦀 Rust environment loaded"
            echo "Rust: $(rustc --version)"
            echo "Cargo: $(cargo --version)"
            echo "Rust Analyzer: available"
            export PROJECT_ROOT=$PWD

            # Set cargo home to project directory
            export CARGO_HOME=$PWD/.cargo

            # Add cargo binaries to path
            export PATH=$CARGO_HOME/bin:$PATH

            if [ ! -f "Cargo.toml" ]; then
              echo "💡 Initialize project with:"
              echo "   Binary:  cargo init"
              echo "   Library: cargo init --lib"
            fi

            echo "🔧 Tools: cargo-watch, cargo-edit, cargo-audit, bacon"
            echo "💡 Run 'cargo watch -x run' for auto-recompile"
          '';
        };
      }
    );
}
