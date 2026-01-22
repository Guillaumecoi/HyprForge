{
  description = "QEMU/KVM VM Development Environment";

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
            qemu
            qemu_kvm

            # Basic utilities
            wget
            curl

            # Optional: VM Management
            virt-manager # GUI for managing VMs
            # libvirt  # VM management API
            virtiofsd # Shared folder support

            # Optional: Additional tools
            ovmf # UEFI firmware
            # swtpm  # TPM emulator

            # Optional: Remote access
            # freerdp  # RDP client
            # tigervnc  # VNC client
          ];

          shellHook = ''
            echo "🖥️  QEMU/KVM environment loaded"
            export PROJECT_ROOT=$PWD
          '';
        };
      }
    );
}
