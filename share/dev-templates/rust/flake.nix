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

            # System libraries
            pkg-config
            openssl

            # Optional: Development tools
            # cargo-watch  # Auto-recompile on changes
            # cargo-edit  # cargo add, cargo rm, cargo upgrade
            # cargo-outdated  # Check for outdated dependencies
            # cargo-audit  # Security vulnerability scanner
            # cargo-flamegraph  # Profiling
            # cargo-nextest  # Better testing
            # cargo-expand  # Expand macros

            # Optional: Code coverage
            # cargo-tarpaulin

            # Optional: Cross-compilation
            # cargo-cross

            # Optional: Background checker
            # bacon
          ];

          shellHook = ''
            echo "🦀 Rust environment loaded"
            export PROJECT_ROOT=$PWD
          '';
        };
      }
    );
}
