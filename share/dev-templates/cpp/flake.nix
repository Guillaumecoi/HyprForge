{
  description = "C++ Development Environment";

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
            # Compilers
            gcc

            # Build system
            cmake
            gnumake

            # Development tools
            gdb
            pkg-config

            # Optional: Additional compilers
            # clang
            # llvm

            # Optional: Build systems
            # ninja
            # meson

            # Optional: Debugging and profiling
            # lldb
            # valgrind

            # Optional: Static analysis and formatting
            # clang-tools  # includes clang-format, clang-tidy
            # cppcheck

            # Optional: Package managers
            # conan
            # vcpkg

            # Optional: Testing libraries
            # boost
            # catch2
            # gtest

            # Optional: Documentation
            # doxygen

            # Optional: Performance
            # ccache
          ];

          shellHook = ''
            echo "⚙️  C++ environment loaded"
            export PROJECT_ROOT=$PWD
          '';
        };
      }
    );
}
