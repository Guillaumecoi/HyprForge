# Complete Package List

All 160+ packages available in HyprForge, organized by category. This list shows every package configured in [home/packages.nix](../home/packages.nix) and [system/packages.nix](../system/packages.nix).

## How to Use This List

1. Find packages you want
2. Uncomment in [home/packages.nix](../home/packages.nix)
3. Run `homeswitch` to install
4. Comment out to remove

---

## Development Tools

### Editors & IDEs

- **neovim** - Vim-based terminal editor (pre-configured with plugins)
- **vscode** - Visual Studio Code (pre-configured with extensions)
- **micro** - Modern terminal editor (nano alternative)

### Version Control

- **git** - Git version control (configured with your details from user.nix)
- **gh** - GitHub CLI
- **lazygit** - Terminal UI for git
- **delta** - Better git diff viewer

### Containers

- **podman** - Rootless container runtime
- **podman-compose** - Docker Compose for Podman
- **podman-tui** - Terminal UI for Podman management
- ~~**docker**~~ - Traditional Docker (commented by default, enable in configuration.nix)

### Development Tools

- **direnv** - Automatic environment switcher
- **nixfmt-rfc-style** - Nix code formatter
- **nixpkgs-fmt** - Alternative Nix formatter
- **nixd** - Nix language server for IDEs
- **taplo** - TOML formatter
- **nodePackages.prettier** - JSON/CSS/Markdown formatter
- **nodejs** - Node.js runtime

### API & HTTP Tools

- **httpie** - User-friendly HTTP CLI client
- **python313Packages.grequests** - Async HTTP for Python (used by weather.py)

### AI Assistants

- **github-copilot-cli** - GitHub Copilot command-line interface
- **claude-code** - Claude AI CLI tool

---

## Shell & Terminal

### Shell

- **zsh** - Z shell (default interactive shell)
- **bash** - Bourne Again Shell (for script compatibility)
- **oh-my-zsh** - Zsh plugin framework
- **starship** - Cross-shell prompt

### Terminal Emulator

- **kitty** - GPU-accelerated terminal emulator (pre-configured)

### Terminal Utilities

- **zoxide** - Smarter cd command with frecency
- **ripgrep** - Faster grep alternative
- **fzf** - Fuzzy finder for command line
- **bat** - Cat clone with syntax highlighting
- **fd** - Faster find alternative

---

## Desktop Environment (Wayland/Hyprland)

### Core Desktop

- **hyprland** - Dynamic tiling Wayland compositor
- **swww** - Wallpaper daemon for Wayland
- **waybar** - Highly customizable status bar
- **rofi** - Application launcher and window switcher
- **dunst** - Lightweight notification daemon
- **wlogout** - Logout/suspend/shutdown menu
- **hyprlock** - Screen locker for Hyprland

### Appearance

- **bibata-cursors** - Modern cursor theme
- **gtk** - GTK runtime for GTK applications
- **nwg-displays** - Display configuration GUI

### Utilities

- **hyprpicker** - Color picker for Wayland
- **cliphist** - Clipboard history manager

---

## System Utilities

### System Monitoring

- **btop** - Modern resource monitor (TUI)
- **htop** - Interactive process viewer (alternative to top)
- **fastfetch** - System information display
- **gnome-system-monitor** - System monitor GUI
- **hwinfo** - Detailed hardware information
- **lshw** - List hardware configuration

### Disk & Storage

- **yazi** - Modern terminal file manager (pre-configured)
- **xfce.thunar** - Lightweight GUI file manager
- **ncdu** - Disk usage analyzer (TUI)
- **gnome-disk-utility** - Disk management GUI
- **popsicle** - USB flasher utility
- **kdePackages.ark** - Archive manager
- ~~**kdePackages.dolphin**~~ - KDE file manager (commented)
- ~~**nautilus**~~ - GNOME file manager (commented)

---

## Security & Secrets

### Password Management

- **bitwarden-cli** - Bitwarden CLI interface
- **bitwarden-desktop** - Bitwarden GUI (optional)

### Encryption & Keys

- **gnupg** - GPG encryption toolkit
- **age** - Modern encryption tool
- **libsecret** - Secret Service API library

---

## Multimedia

### Screenshots & Screen Capture

- **grim** - Screenshot utility for Wayland
- **slurp** - Screen region selector
- **wayfreeze** - Freeze screen for screenshots
- **satty** - Screenshot annotation tool
- ~~**wf-recorder**~~ - Screen recording (commented)
- ~~**obs-studio**~~ - Advanced streaming/recording (commented)

### Media Players

- **vlc** - VLC media player
- **mpv** - Minimal command-line media player
- **imv** - Minimal image viewer for Wayland

### Media Processing

- **ffmpeg** - Complete video/audio processing toolkit
- **imagemagick** - Image manipulation suite
- **poppler** - PDF rendering library and utilities
- **resvg** - Fast SVG renderer

---

## Device Connectivity

- **libmtp** - Media Transfer Protocol for Android devices
- **gphoto2** - Camera control and file transfer
- **libgphoto2** - Library for camera support
- **kdePackages.kdeconnect-kde** - Phone integration (file transfer, notifications)

---

## Internet & Communication

### Web Browsers

- **firefox** - Mozilla Firefox (pre-configured with extensions)
- **brave** - Privacy-focused Chromium browser
- ~~**chromium**~~ - Open-source Chrome (commented)
- ~~**tor-browser**~~ - Anonymous browsing (commented)

### Messaging & Communication

- **signal-desktop** - Secure private messaging
- **telegram-desktop** - Cloud-based messaging
- **webcord** - Discord client (privacy-respecting)
- ~~**slack**~~ - Work communication platform (commented)

---

## Productivity

### Office Suites

- **libreoffice-fresh** - Complete office suite
- ~~**onlyoffice-desktopeditors**~~ - MS Office compatible suite (commented)

### Document Viewers

- **zathura** - Minimal vim-style PDF/ePub viewer
- ~~**kdePackages.okular**~~ - Universal document viewer (commented)
- ~~**evince**~~ - GNOME document viewer (commented)

### Email

- ~~**thunderbird**~~ - Email client (commented)

### Note-Taking

- **obsidian** - Markdown-based knowledge base
- ~~**joplin-desktop**~~ - Evernote alternative (commented)
- ~~**logseq**~~ - Outliner-style notes (commented)
- ~~**anki**~~ - Spaced repetition flashcards (commented)

### Task Management

- **super-productivity** - Task manager with Pomodoro timer
- **taskwarrior3** - Command-line task management
- **taskwarrior-tui** - TUI for TaskWarrior

---

## Gaming

All gaming packages are commented by default. Uncomment to enable:

- ~~**steam**~~ - Steam gaming platform
- ~~**lutris**~~ - Multi-platform game launcher (Epic, GOG, etc.)
- ~~**heroic**~~ - Epic Games and GOG launcher
- ~~**gamemode**~~ - Automatic gaming optimizations
- ~~**mangohud**~~ - Gaming performance overlay

---

## System Packages

Located in [system/packages.nix](../system/packages.nix). These are installed system-wide:

### Core System Utilities

- **home-manager** - User environment manager
- **git** - Version control (system-level)
- **vim** - Fallback text editor
- **wget** - File downloader
- **curl** - URL data transfer tool
- **file** - File type identifier
- **unzip** - ZIP archive extractor
- **p7zip** - 7-Zip compression
- **unrar** - RAR archive extractor
- **jq** - JSON processor

### Wayland Core Tools

- **wl-clipboard-rs** - Clipboard utilities (wl-copy/wl-paste)
- **wl-clip-persist** - Keep clipboard after app closes
- **bibata-cursors** - System-wide cursor theme (for display managers)

### Hardware Support

- **wireplumber** - PipeWire session manager
- **pavucontrol** - PulseAudio volume control GUI
- ~~**bluez**~~ - Bluetooth stack (commented)
- ~~**blueman**~~ - Bluetooth manager GUI (commented)

### Programming Languages (System-level)

- **python3** - Python interpreter
- **python3Packages.pip** - Python package installer

### Laptop Hardware Tools

- **brightnessctl** - Screen brightness control
- **powertop** - Power consumption monitor
- **tlp** - Advanced power management
- **acpi** - Battery status information

---

## Development Templates

Not installed system-wide. Available as isolated environments in [share/dev-templates/](../share/dev-templates/):

- **python-ml/** - NumPy, Pandas, Scikit-learn, Matplotlib, Jupyter
- **python-web/** - Flask, FastAPI, SQLAlchemy
- **rust/** - Complete Rust toolchain
- **cpp/** - GCC, CMake, GDB, Valgrind
- **nodejs/** - Node, npm, TypeScript, ESLint
- **java/** - JDK, Maven, Gradle
- **pentesting/** - Nmap, Metasploit, Burp Suite, Wireshark
- **cad-hardware/** - KiCad, OpenSCAD, FreeCAD

See [dev-templates/README.md](../share/dev-templates/README.md) for usage.

---

## Custom Scripts

Located in [home/scripts/](../home/scripts/), automatically available in `$PATH`:

- **dev-init.sh** - Initialize development environment
- **emoji-picker.sh** - Emoji selection menu
- **glyph-picker.sh** - Symbol/glyph picker
- **hint-hyprland.py** - Keybinding hint system
- **keybinds-hint.sh** - Show keybindings menu
- **replace-tabs.sh** - Replace tabs with spaces in files
- **screenshot-annotate.sh** - Screenshot with annotation
- **wallpaper-rotate.sh** - Cycle through wallpapers
- **weather.py** - Weather information for Waybar

---

## Adding New Packages

### From nixpkgs

1. Search for package:

```bash
nix search nixpkgs <name>
```

2. Add to [home/packages.nix](../home/packages.nix):

```nix
[
  "package-name"
]
```

3. Rebuild:

```bash
homeswitch
```

### Nested Packages

Some packages are nested (e.g., `nodePackages.prettier`):

```nix
[
  "nodePackages.prettier"
  "python3Packages.numpy"
  "kdePackages.ark"
]
```

The system automatically resolves the path!

---

## Package Categories Reference

| Category            | File                 | Count          |
| ------------------- | -------------------- | -------------- |
| Development         | home/packages.nix    | ~30            |
| Shell & Terminal    | home/packages.nix    | ~15            |
| Desktop Environment | home/packages.nix    | ~15            |
| System Utilities    | home/packages.nix    | ~10            |
| Security            | home/packages.nix    | ~5             |
| Multimedia          | home/packages.nix    | ~10            |
| Connectivity        | home/packages.nix    | ~5             |
| Internet            | home/packages.nix    | ~10            |
| Productivity        | home/packages.nix    | ~15            |
| Gaming              | home/packages.nix    | ~5 (commented) |
| System-wide         | system/packages.nix  | ~25            |
| Dev Templates       | share/dev-templates/ | 8 environments |
| Custom Scripts      | home/scripts/        | 9 scripts      |

**Total: 160+ packages + 8 dev environments**

---

## Tips

- **Comment packages you're unsure about** - Easy to enable later
- **Use dev templates** instead of system packages for project-specific tools
- **Keep system/packages.nix minimal** - Most things belong in home/packages.nix
- **Document why you installed something** - Add comments in packages.nix
- **Search before adding** - Package might already be in the list, commented out

---

For more information:

- [USAGE.md](USAGE.md) - How to manage packages
- [FAQ.md](FAQ.md) - Common questions
- [ARCHITECTURE.md](ARCHITECTURE.md) - How package management works
