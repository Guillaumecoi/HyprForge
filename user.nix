{
  # Hostname and username configuration
  username = "youruser";
  hostname = "yourhostname";

  # System-specific hardware configuration
  hasNvidiaGpu = false;

  # Swap configuration
  # For encrypted swap: set to null (hardware-configuration.nix handles it)
  # For unencrypted swap: set to "/dev/disk/by-uuid/YOUR-SWAP-UUID"
  # For swap file: set to "/swapfile" (or custom path)
  swapDevice = null;
  swapSizeGB = 16;

  # Printer configuration (empty list = no printing)
  printerDrivers = [ ];
}
