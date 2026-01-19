{ pkgs, ... }:

{
  # Podman configuration for rootless containers
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Docker CLI compatibility (alias docker=podman)
    defaultNetwork.settings.dns_enabled = true; # Enable DNS for containers
  };
}
