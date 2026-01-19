# VSCode Extensions
# Extensions defined here are declaratively managed
# User-installed extensions are preserved due to mutableExtensionsDir = true

{ pkgs-unstable, ... }:

with pkgs-unstable.vscode-extensions;
[
  # Language Support
  ms-python.python
  bbenoist.nix

  # Development Tools
  mkhl.direnv

  # Editor Enhancements
  vscodevim.vim
]
