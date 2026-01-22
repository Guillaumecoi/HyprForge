# Default applications configuration
# The canonical source for default app definitions
# Used by environment/default.nix (env vars), keybindings/default.nix, and keybindings/global.nix
{
  # Application definitions
  apps = {
    terminal = "kitty";
    editor = "nvim";
    editorAlt = "code";
    browser = "firefox";
    browserAlt = "brave";
    explorer = "kitty -e yazi";
    explorerAlt = "thunar";
    notes = "obsidian";
    aiCli = "copilot";
  };

  # XDG MIME type associations - sets default applications for file types and protocols
  mimeApps = {
    enable = true;
    defaultApplications = {
      # Web browsers
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";

      # File manager
      "inode/directory" = "thunar.desktop";

      # Text editor
      "text/plain" = "code.desktop";
      "application/x-shellscript" = "code.desktop";

      # Image viewer
      "image/jpeg" = "org.gnome.eog.desktop";
      "image/png" = "org.gnome.eog.desktop";
      "image/gif" = "org.gnome.eog.desktop";
      "image/webp" = "org.gnome.eog.desktop";
      "image/svg+xml" = "org.gnome.eog.desktop";

      # PDF viewer
      "application/pdf" = "org.pwmt.zathura.desktop";

      # Video player
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";

      # Audio player
      "audio/mpeg" = "mpv.desktop";
      "audio/flac" = "mpv.desktop";
      "audio/ogg" = "mpv.desktop";
    };
  };
}
