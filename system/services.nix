{ pkgs, ... }:

{
  # Podman configuration for rootless containers
  # Uncomment to enable Podman, Also add "podman" to home/packages.nix or system/packages.nix
  # virtualisation.podman = {
  #   enable = true;
  #   dockerCompat = true; # Docker CLI compatibility (alias docker=podman)
  #   defaultNetwork.settings.dns_enabled = true; # Enable DNS for containers
  # };

  # Flatpak support - enabled system-wide but packages installed at user level
  # Users install packages via flatpak commands or home/flatpak.nix activation
  services.flatpak.enable = true;

}
