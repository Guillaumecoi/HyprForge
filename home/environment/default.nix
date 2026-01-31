# Central environment configuration
# Entry point that imports all environment submodules
{ ... }:

{
  imports = [
    ./xdg.nix
    ./session.nix
  ];
}
