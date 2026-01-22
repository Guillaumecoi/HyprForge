{
  description = "Java Development Environment";

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
            # JDK (Be sure to also set this as JAVA_HOME in shellHook)
            jdk21 # OpenJDK 21
            # jdk25 # Uncomment to use OpenJDK 25

            # Build tool
            maven

            # Optional: Additional build tools
            # gradle
            # ant

            # Optional: Spring Boot CLI
            # spring-boot-cli

            # Optional: Development tools
            # lombok

            # Optional: Code quality
            # checkstyle
          ];

          shellHook = ''
            echo "☕ Java environment loaded"
            export PROJECT_ROOT=$PWD
            export JAVA_HOME=${pkgs.jdk21}
          '';
        };
      }
    );
}
