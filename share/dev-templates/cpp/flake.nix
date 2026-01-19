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
            clang
            llvm

            # Build systems
            cmake
            gnumake
            ninja
            meson

            # Debuggers and profilers
            gdb
            lldb
            valgrind

            # Static analysis and formatting
            clang-tools # includes clang-format, clang-tidy
            cppcheck

            # Package managers
            conan
            vcpkg

            # Libraries (common ones)
            boost
            catch2
            gtest

            # Documentation
            doxygen

            # Development tools
            ccache
            pkg-config
          ];

          shellHook = ''
            echo "⚙️  C++ environment loaded"
            echo "GCC: $(gcc --version | head -n1)"
            echo "Clang: $(clang --version | head -n1)"
            echo "CMake: $(cmake --version | head -n1)"
            echo "Available: gdb, valgrind, clang-format, cppcheck"
            export PROJECT_ROOT=$PWD

            # Set up ccache
            export CC="ccache gcc"
            export CXX="ccache g++"

            # Create build directory if it doesn't exist
            if [ ! -d "build" ]; then
              echo "💡 Run 'cmake -B build' to generate build files"
            fi

            echo "🔧 Build systems: CMake, Make, Ninja, Meson"
          '';
        };
      }
    );
}
