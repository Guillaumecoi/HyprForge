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
            # JDK (OpenJDK 21 - latest LTS)
            jdk21

            # Build tools
            maven
            gradle
            ant

            # Spring Boot CLI
            spring-boot-cli

            # Development tools
            lombok

            # Testing frameworks (via Maven/Gradle)
            # junit, mockito, testng (added via project dependencies)

            # Code quality
            checkstyle

            # Documentation
            # javadoc (included in JDK)
          ];

          shellHook = ''
            echo "☕ Java environment loaded"
            echo "Java: $(java -version 2>&1 | head -n1)"
            echo "Maven: $(mvn --version | head -n1)"
            echo "Gradle: $(gradle --version | grep Gradle)"
            export PROJECT_ROOT=$PWD
            export JAVA_HOME=${pkgs.jdk21}

            # Set up Java options
            export _JAVA_OPTIONS="-Xmx2g -XX:+UseG1GC"

            # Maven local repository in project
            export MAVEN_OPTS="-Dmaven.repo.local=$PWD/.m2/repository"

            # Gradle cache in project
            export GRADLE_USER_HOME=$PWD/.gradle

            if [ ! -f "pom.xml" ] && [ ! -f "build.gradle" ] && [ ! -f "build.gradle.kts" ]; then
              echo "💡 Initialize project with:"
              echo "   Maven:  mvn archetype:generate"
              echo "   Gradle: gradle init"
              echo "   Spring: spring init --dependencies=web ."
            fi

            echo "🔧 Build tools: Maven, Gradle, Ant, Spring Boot CLI"
          '';
        };
      }
    );
}
