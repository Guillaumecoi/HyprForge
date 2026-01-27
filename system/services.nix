{ pkgs, ... }:

{
  # Podman configuration for rootless containers
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Docker CLI compatibility (alias docker=podman)
    defaultNetwork.settings.dns_enabled = true; # Enable DNS for containers
  };

  # Enable VirtualBox host kernel modules
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true; # Required for USB 2.0/3.0, RDP, PXE boot, etc.
  };

}
