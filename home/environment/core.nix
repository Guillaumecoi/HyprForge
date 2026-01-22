# Core environment variables for default applications
# Imports app definitions from apps.nix
let
  appsModule = import ./apps.nix;
  apps = appsModule.apps;
in
{
  # Environment variables for default applications
  core = {
    TERMINAL = apps.terminal;
    EDITOR = apps.editor; # CLI editor for shell
    VISUAL = apps.editorAlt; # GUI editor
    BROWSER = apps.browser;
    BROWSER_ALT = apps.browserAlt;
    EXPLORER = apps.explorer;
    EXPLORER_ALT = apps.explorerAlt;
    NOTES = apps.notes;
    AI_CLI = apps.aiCli;
  };
}
