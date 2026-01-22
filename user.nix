{
  # Hostname and username configuration
  username = "guillaume";
  hostname = "legion7";

  # System-specific hardware configuration
  hasNvidiaGpu = true;

  # Swap configuration
  # For encrypted swap: set to null (hardware-configuration.nix handles it)
  # For unencrypted swap: set to "/dev/disk/by-uuid/YOUR-SWAP-UUID"
  swapDevice = null;
  swapSizeGB = 16;

  # Printer configuration (empty list = no printing)
  printerDrivers = [ "epson-escpr2" "epson-escpr" ];
}
