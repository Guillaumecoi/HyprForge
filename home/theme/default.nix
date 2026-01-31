# Theme configuration
# Entry point that imports all theme submodules
{ ... }:

{
  imports = [
    ./catppuccin.nix
    ./session.nix
  ];
}
