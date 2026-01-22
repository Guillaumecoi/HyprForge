# Central environment configuration
# Main entry point that exports all environment modules
{ config, pkgs, lib, ... }:

let
  # Import all environment modules
  appsModule = import ./apps.nix;
  coreModule = import ./core.nix;
  waybarModule = import ./waybar.nix;

  # Extract components
  apps = appsModule.apps;
  mimeApps = appsModule.mimeApps;
  core = coreModule.core;
  weather = waybarModule.weather;

  # Merge all environment variables for session
  allEnvVars = core // weather;

  # Generate .env file content for scripts
  envFileContent =
    lib.concatStringsSep "\n" (lib.mapAttrsToList (name: value: "${name}=${value}") allEnvVars) + "\n";
in
{
  # Export session variables (available to all programs)
  home.sessionVariables = lib.mkForce allEnvVars;

  # Create .env file for scripts that source it
  home.file."scripts/.env".text = envFileContent;

  # Configure XDG MIME type associations (default applications)
  xdg.mimeApps = mimeApps;
}
