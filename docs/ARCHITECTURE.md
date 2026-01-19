# Architecture Documentation

Deep dive into how HyprForge works internally. This explains the design decisions, patterns, and mechanisms that make the system elegant and maintainable.

## Table of Contents

- [System Overview](#system-overview)
- [The Two-File Package System](#the-two-file-package-system)
- [Centralized Keybinding System](#centralized-keybinding-system)
- [Auto-Import Magic](#auto-import-magic)
- [Home Manager Integration](#home-manager-integration)
- [Flake Architecture](#flake-architecture)
- [Build Process](#build-process)
- [Design Philosophy](#design-philosophy)

---

## System Overview

HyprForge is built on **NixOS** with **Home Manager** for user configuration. The architecture separates concerns into clear domains:

```
HyprForge/
├── flake.nix              # Entry point - defines system
├── user.nix               # Machine-specific settings
├── configuration.nix      # System-level config (NixOS)
├── home.nix              # User-level config (Home Manager)
│
├── system/               # System packages & services
│   ├── packages.nix      # System-wide packages
│   ├── services.nix      # Systemd services
│   ├── fonts.nix         # Font configuration
│   └── sddm.nix          # Login manager
│
├── home/                 # User environment
│   ├── packages.nix      # User packages (THE LIST)
│   ├── keybindings/      # Centralized keybinding system
│   ├── programs/         # Per-app configs (auto-imported)
│   ├── scripts/          # Custom scripts (auto-wrapped)
│   └── environment.nix   # Environment variables
│
└── theme/
    └── theme.nix         # Catppuccin color palette
```

### Flow of Configuration

```
flake.nix
   ├─> nixosModules.${hostname}
   │    ├─> configuration.nix (system config)
   │    ├─> system/* (packages, services, fonts)
   │    └─> hardware-configuration.nix (auto-generated)
   │
   └─> homeConfigurations.${username}
        ├─> home.nix (user config)
        ├─> home/packages.nix (package list)
        ├─> home/keybindings/* (keybindings)
        └─> home/programs/* (auto-imported configs)
```

---

## The Two-File Package System

### The Problem It Solves

Traditional Linux systems obscure what's installed:
- Hidden dependencies
- Orphaned packages
- Mystery bloat
- "What is this and why do I have it?"

### The Solution

**All packages explicitly declared in 2 files:**

1. **[home/packages.nix](../home/packages.nix)** - User applications
2. **[system/packages.nix](../system/packages.nix)** - System utilities

### Implementation

#### Simple String List

Instead of traditional Nix attribute sets, packages are a simple string list:

```nix
# home/packages.nix
{ pkgs, pkgs-unstable }:

[
  "firefox"
  "spotify"
  "vlc"
  "nodePackages.prettier"  # Nested packages work too
]
```

#### Automatic Resolution in home.nix

The magic happens in [home.nix](../home.nix):

```nix
let
  packageList = import ./home/packages.nix { inherit pkgs pkgs-unstable; };

  # Helper to resolve nested paths like "nodePackages.prettier"
  getPackage = name:
    let
      parts = lib.splitString "." name;
      resolve = attrs: path:
        if path == [] then attrs
        else resolve (attrs.${builtins.head path}) (builtins.tail path);
    in
    resolve pkgs parts;

  # Check if package has a Home Manager module
  hasHmModule = name:
    builtins.elem (builtins.head (lib.splitString "." name)) knownHmPrograms
    || builtins.elem (builtins.head (lib.splitString "." name)) knownHmServices;

  # Split packages by category
  hmProgramModules = builtins.filter (p: ...) packageList;
  barePackages = builtins.filter (p: !(hasHmModule p)) packageList;
in
{
  # Install bare packages
  home.packages = map getPackage barePackages;

  # Auto-enable HM modules
  programs = builtins.listToAttrs (
    map (name: { name = name; value = { enable = true; }; }) hmProgramModules
  );
}
```

#### Why This Is Awesome

**Benefits:**
1. **Single source of truth** - One list, everything visible
2. **No duplication** - Don't specify both `home.packages.firefox` and `programs.firefox.enable`
3. **Automatic optimization** - System detects HM modules and enables them
4. **Simple syntax** - Just add a string, no Nix boilerplate
5. **Comments work** - Document why you installed something

**Example:**
```nix
[
  "obs-studio"     # Has HM module → programs.obs-studio.enable = true
  "spotify"        # No HM module → home.packages = [ spotify ]
  # "steam"        # Commented = not installed
]
```

### Known Home Manager Modules

Lists stored in JSON files, updated with a custom script:

- **[home/hm-programs.json](../home/hm-programs.json)** - Programs with HM modules
- **[home/hm-services.json](../home/hm-services.json)** - Services with HM modules
- **[home/hm-misc.json](../home/hm-misc.json)** - Misc HM options

Update: `./home/local-scripts/update-hm-programs.sh`

---

## Centralized Keybinding System

### The Problem

Changing a keybinding like "new tab" requires editing:
- Kitty config
- Firefox settings
- VSCode keybindings
- Neovim mappings
- Yazi config
- 5+ other places...

**Result:** Inconsistency, maintenance hell, giving up.

### The Solution

**Define once, auto-apply everywhere.**

### Architecture

```
home/keybindings/
├── default.nix          # Exports everything
├── local.nix            # App keybindings (CTRL, ALT)
├── global.nix           # WM keybindings (SUPER)
├── apps.nix             # Default applications
└── converters.nix       # Format converters
```

### How It Works

#### 1. Define Keybindings Centrally

In [home/keybindings/local.nix](../home/keybindings/local.nix):

```nix
{
  tabs = {
    new = "ctrl+t";
    close = "ctrl+w";
    next = "ctrl+tab";
    prev = "ctrl+shift+tab";
    reopen = "ctrl+shift+t";
  };

  editing = {
    save = "ctrl+s";
    undo = "ctrl+z";
    redo = "ctrl+shift+z";
  };
}
```

#### 2. Create Format Converters

In [home/keybindings/converters.nix](../home/keybindings/converters.nix):

```nix
{
  # Kitty uses different format: "ctrl+t" → "ctrl+shift+t"
  toKitty = bindings: {
    new = translateKey bindings.new;
    close = translateKey bindings.close;
    # ... etc
  };

  # Neovim uses Vim notation: "ctrl+t" → "<C-t>"
  toNeovim = bindings: {
    new = vimKey bindings.new;
    close = vimKey bindings.close;
  };

  # VSCode uses JSON format
  toVSCode = bindings: /* ... */;
}
```

#### 3. Import in Program Configs

In [home/programs/kitty/kitty.nix](../home/programs/kitty/kitty.nix):

```nix
let
  kb = import ../../keybindings { inherit lib; };
  keys = kb.toKitty kb.tabs;  # Convert to Kitty format
in
{
  programs.kitty = {
    enable = true;
    keybindings = {
      "${keys.new}" = "new_tab";       # Uses converted key
      "${keys.close}" = "close_tab";
      "${keys.next}" = "next_tab";
    };
  };
}
```

#### 4. Rebuild Applies Everywhere

```bash
homeswitch  # All apps get new keybindings automatically
```

### Default Applications

[home/keybindings/apps.nix](../home/keybindings/apps.nix):

```nix
{
  terminal = "kitty";
  editor = "code";
  browser = "firefox";
  explorer = "kitty -e yazi";
}
```

This propagates to:
- Hyprland keybindings (`$TERMINAL`)
- Environment variables (`$TERMINAL`, `$EDITOR`)
- Rofi defaults
- Script defaults

**Change once → updates system-wide.**

### Why This Architecture Works

**Separation of Concerns:**
- **Definition** (local.nix, global.nix) - What the shortcut is
- **Translation** (converters.nix) - How each app wants it formatted
- **Application** (programs/*/nix) - Where it's used

**Benefits:**
1. **Single source of truth** - One place to change shortcuts
2. **Consistency** - Same shortcut does same thing everywhere
3. **Maintainability** - Add new app once, keybindings follow
4. **Type safety** - Nix catches invalid references
5. **Documentation** - Keybindings are self-documenting

---

## Auto-Import Magic

### Program Auto-Discovery

[home.nix](../home.nix) automatically imports all program configs:

```nix
let
  # Scan home/programs/ directory
  programEntries = builtins.attrNames (builtins.readDir ./home/programs);

  # Filter for directories only
  programDirs = builtins.filter (name:
    let entry = builtins.readDir ./home/programs;
    in entry.${name} == "directory"
  ) programEntries;

  # Build import paths: programs/foo/foo.nix
  programImports = map (dir: ./home/programs/${dir}/${dir}.nix) programDirs;
in
{
  imports = programImports ++ [ /* other imports */ ];
}
```

**Result:** Just create `programs/myapp/myapp.nix` and it's automatically loaded!

### Script Auto-Wrapping

[home/scripts.nix](../home/scripts.nix) wraps scripts automatically:

```nix
let
  scriptsDir = ./scripts;
  entries = builtins.attrNames (builtins.readDir scriptsDir);

  # Find all .sh files
  shFiles = builtins.filter (f: builtins.match ".*\\.sh" f != null) entries;

  # Wrap each as executable
  mkScript = file:
    let
      name = builtins.replaceStrings [".sh"] [""] file;
      src = builtins.readFile "${scriptsDir}/${file}";
    in
    pkgs.writeShellScriptBin name src;

  scripts = map mkScript shFiles;
in
{
  home.packages = scripts;
}
```

**Drop a script → it's in your `$PATH`.**

### Why Auto-Import?

**Reduces boilerplate:**
- No manual imports in home.nix
- No maintenance when adding programs
- Directory structure = configuration structure

**Convention over configuration:**
- Predictable: `programs/foo/foo.nix`
- Self-documenting
- Easy to navigate

---

## Home Manager Integration

### The Home Manager Advantage

Home Manager provides:
- Declarative user configuration
- File management (`home.file`)
- XDG directory setup
- Service management (user systemd)
- Program modules with built-in options

### Why Not Just NixOS Modules?

**System vs User:**
- System modules require `sudo` to change
- User modules are per-user, no root needed
- Home Manager manages dotfiles, NixOS manages system

### The Hybrid Approach

HyprForge uses both:

```nix
# configuration.nix (system-level)
{
  programs.hyprland.enable = true;  # Install Hyprland
  services.printing.enable = true;   # Enable printing
}

# home.nix (user-level)
{
  programs.firefox = {               # Configure Firefox
    enable = true;
    profiles.default = { /* ... */ };
  };
}
```

**System** = Hardware, services, drivers
**Home** = Apps, configs, dotfiles

---

## Flake Architecture

### Flake Inputs

[flake.nix](../flake.nix) defines dependencies:

```nix
inputs = {
  nixpkgs.url = "nixpkgs/nixos-unstable";  # Package repository

  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";    # Use same nixpkgs
  };

  catppuccin.url = "github:catppuccin/nix";  # Theme modules
  nur.url = "github:nix-community/NUR";      # Nix User Repository
};
```

### Flake Outputs

```nix
outputs = { nixpkgs, home-manager, ... }@inputs:
  let
    user = import ./user.nix;
    system = "x86_64-linux";
  in
  {
    # NixOS configuration
    nixosConfigurations.${user.hostname} = nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
      ];
    };

    # Home Manager configuration (standalone)
    homeConfigurations.${user.username} = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs { inherit system; };
      modules = [ ./home.nix ];
    };
  };
```

### Why Flakes?

**Reproducibility:**
- `flake.lock` pins exact versions
- Same config → identical result anywhere

**Composability:**
- Easy to pull modules from other sources
- Clean dependency management

**Modern:**
- Standard for new Nix projects
- Better than channels for complex setups

---

## Build Process

### System Rebuild

```bash
sudo nixos-rebuild switch --flake ~/HyprForge#$(hostname)
```

**What happens:**
1. Flake evaluates with your hostname
2. `configuration.nix` loaded with all system modules
3. `user.nix` provides machine-specific settings
4. System generation built in `/nix/store`
5. Symlink `/run/current-system` updated
6. Services restarted as needed
7. Bootloader entry added (for rollback)

### Home Manager Rebuild

```bash
home-manager switch --flake ~/HyprForge#$(hostname)
```

**What happens:**
1. Flake evaluates `homeConfigurations`
2. `home.nix` processes package list
3. Programs auto-detected and enabled
4. Keybindings converted and applied
5. Scripts wrapped and installed
6. Dotfiles generated/copied
7. User generation built
8. Home symlinks updated

### Dependency Graph

```
flake.nix
  ↓
nixpkgs (package set)
  ↓
configuration.nix → user.nix (machine settings)
  ↓                    ↓
system/packages.nix   hardware-configuration.nix
  ↓
home-manager
  ↓
home.nix → home/packages.nix (package list)
  ↓           ↓
  ↓      [auto-detect HM modules]
  ↓           ↓
  ↓      programs.*.enable = true
  ↓
home/programs/* (configs)
  ↓
keybindings/* (centralized)
```

---

## Design Philosophy

### Explicit Over Implicit

**Traditional:**
- Hidden dependencies
- Auto-installed recommends
- Mystery background services

**HyprForge:**
- Everything declared explicitly
- No hidden packages
- Services visible in config

### Declarative Configuration

**Imperative (traditional):**
```bash
sudo apt install firefox
cp firefox-config ~/.mozilla/
sudo systemctl enable bluetooth
```

**Declarative (HyprForge):**
```nix
home.packages = [ "firefox" ];
programs.firefox.profiles.default = { /* ... */ };
services.bluetooth.enable = true;
```

**Benefits:**
- Reproducible
- Version controlled
- Rollback-able
- Auditable

### Convention Over Configuration

**Auto-import programs:**
- Create `programs/myapp/myapp.nix`
- No manual import needed

**Auto-wrap scripts:**
- Drop `script.sh` in `scripts/`
- Available in `$PATH` immediately

**Auto-enable HM modules:**
- Add to `packages.nix`
- System detects if HM module exists
- Enables automatically

### Separation of Concerns

**Clear boundaries:**
- System vs User
- Global vs Local keybindings
- Packages vs Configuration

**Result:**
- Easy to understand
- Simple to maintain
- Clear where to make changes

### Maintainability First

**Priorities:**
1. **Readable** - Code should explain itself
2. **Modular** - Change one thing without affecting others
3. **Consistent** - Same patterns throughout
4. **Documented** - Comments explain *why*

### The Unix Philosophy Applied

**Do one thing well:**
- `packages.nix` - Just list packages
- `keybindings/` - Just define shortcuts
- `programs/` - Just configure apps

**Compose tools:**
- Keybindings + Converters + Programs = Consistent shortcuts
- Package list + HM detection + Auto-enable = Simple management

---

## Extension Points

### Adding New Programs

1. Create `home/programs/myapp/myapp.nix`
2. Import keybindings if needed
3. Configure program
4. Auto-imported on rebuild

### Adding New Keybindings

1. Define in `home/keybindings/local.nix`
2. Create converter in `converters.nix`
3. Use in program configs
4. Rebuild applies everywhere

### Adding New Scripts

1. Drop `.sh` or `.py` in `home/scripts/`
2. Auto-wrapped and installed
3. Available in `$PATH`

### Extending the Theme

1. Edit `theme/theme.nix`
2. Use colors in program configs
3. Consistent theming across apps

---

## Performance Considerations

### Build-Time Optimizations

- **Lazy evaluation** - Only builds what's needed
- **Hashing** - Unchanged packages reused from cache
- **Parallel builds** - Multiple cores utilized

### Runtime Optimizations

- **Hyprland** - Lightweight compositor (~300MB RAM)
- **Minimal services** - Only what's configured runs
- **No bloat** - Explicit package management prevents accumulation

### Disk Space

- **Nix store** - Shared dependencies (saves space)
- **Garbage collection** - Remove old generations
- **Symlinks** - Configs linked, not copied

---

## Security Considerations

### Immutable System

- Root filesystem read-only
- Changes only via rebuild
- Harder to compromise persistently

### Declarative Secrets

- Avoid hardcoded secrets in configs
- Use `age`, `sops`, or similar for encryption
- Environment variables for runtime secrets

### Minimal Attack Surface

- Only configured services run
- No unexpected background processes
- Explicit network services

---

## Future Enhancements

Potential improvements to the architecture:

### Possible Additions

1. **Secret management module** - Integrated `sops` or `age`
2. **Multi-user support** - Per-user configs
3. **Profile system** - Work/personal/gaming profiles
4. **Remote deployment** - Deploy to multiple machines
5. **Testing framework** - Validate configs before deploy

### Maintaining Backwards Compatibility

When changing architecture:
- Keep old patterns working temporarily
- Document migration path
- Provide migration scripts if needed

---

## Learning Resources

To understand this architecture deeper:

### NixOS Concepts
- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Pills](https://nixos.org/guides/nix-pills/) - Learn Nix language
- [Zero to Nix](https://zero-to-nix.com/) - Modern Nix guide

### Home Manager
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Home Manager Options](https://mipmip.github.io/home-manager-option-search/)

### Flakes
- [Flakes Wiki](https://nixos.wiki/wiki/Flakes)
- [Practical Nix Flakes](https://serokell.io/blog/practical-nix-flakes)

---

## Conclusion

HyprForge's architecture prioritizes:
1. **Transparency** - See everything you have
2. **Simplicity** - Easy to understand and modify
3. **Consistency** - Same patterns throughout
4. **Maintainability** - Scale without complexity

The two-file package system and centralized keybindings demonstrate that good architecture makes complex systems feel simple.

---

For more information:
- [USAGE.md](USAGE.md) - How to use the system
- [FAQ.md](FAQ.md) - Common questions
- [PACKAGES.md](PACKAGES.md) - Complete package list
- [KEYBINDINGS.md](KEYBINDINGS.md) - Keybinding reference
