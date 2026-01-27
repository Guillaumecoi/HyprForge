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

    # XDG Base Directory specification
    # Helps keep home directory clean by redirecting app data
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_STATE_HOME = "$HOME/.local/state";
    # Runtime dir - usually provided by systemd --user as /run/user/$UID
    # Provide a safe fallback for environments that don't set it automatically.
    XDG_RUNTIME_DIR = "/run/user/$UID";

    # XDG Desktop Portal and Session variables for Hyprland
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";

    # Zsh - use XDG directories
    ZDOTDIR = "$HOME/.config/zsh";

    # Development tools - keep them in XDG directories
    CARGO_HOME = "$HOME/.local/share/cargo";
    RUSTUP_HOME = "$HOME/.local/share/rustup";
    GOPATH = "$HOME/.local/share/go";
    NPM_CONFIG_USERCONFIG = "$HOME/.config/npm/npmrc";
    NODE_REPL_HISTORY = "$HOME/.local/share/node_repl_history";
    DOCKER_CONFIG = "$HOME/.config/docker";
    MACHINE_STORAGE_PATH = "$HOME/.local/share/docker-machine";

    # Version control
    GIT_CONFIG = "$HOME/.config/git/config";

    # Shell history and tools
    HISTFILE = "$HOME/.local/share/zsh/history";
    LESSHISTFILE = "$HOME/.cache/less/history";

    # Python
    PYTHONSTARTUP = "$HOME/.config/python/pythonrc";
    PYTHON_HISTORY = "$HOME/.local/share/python/history";
    IPYTHONDIR = "$HOME/.config/ipython";
    JUPYTER_CONFIG_DIR = "$HOME/.config/jupyter";

    # Other tools
    GNUPGHOME = "$HOME/.local/share/gnupg";
    WGETRC = "$HOME/.config/wget/wgetrc";
    SCREENRC = "$HOME/.config/screen/screenrc";
    PARALLEL_HOME = "$HOME/.config/parallel";
    SQLITE_HISTORY = "$HOME/.local/share/sqlite_history";
    REDISCLI_HISTFILE = "$HOME/.local/share/redis/rediscli_history";
    AWS_SHARED_CREDENTIALS_FILE = "$HOME/.config/aws/credentials";
    AWS_CONFIG_FILE = "$HOME/.config/aws/config";
    AZURE_CONFIG_DIR = "$HOME/.config/azure";

    # Additional tool-specific variables
    CUDA_CACHE_PATH = "$HOME/.cache/nv";
    DOTNET_CLI_HOME = "$HOME/.local/share/dotnet";
  };
}
