# Keybindings Reference

Complete keybinding guide for HyprForge. Press **SUPER+F1** anytime to see this in a searchable menu!

## Modifier Keys

- **SUPER** (⊞ Windows Key / ⌘ Command) - Window manager actions
- **CTRL** - Application-level actions
- **ALT** - Alternative/quick actions
- **SHIFT** - Modifies behavior of other keys

---

## Philosophy

**SUPER key** - Global window manager actions (Hyprland)

- Window management, workspace switching, launchers

**CTRL key** - Application-specific actions

- Tabs, saving, editing, navigation within apps

**ALT key** - Quick shortcuts and alternatives

- Tab numbers, alternative navigation

This separation prevents conflicts and creates muscle memory consistency.

---

## Global Shortcuts (Window Manager)

### Launchers

| Shortcut            | Action                                |
| ------------------- | ------------------------------------- |
| `SUPER + T`         | Open terminal (Kitty)                 |
| `SUPER + E`         | Open file explorer (Yazi in terminal) |
| `SUPER + C`         | Open text editor (VSCode)             |
| `SUPER + B`         | Open web browser (Firefox)            |
| `SUPER + A`         | Application launcher (Rofi)           |
| `SUPER + TAB`       | Window switcher                       |
| `SUPER + SHIFT + E` | File browser (Rofi)                   |

### Utilities

| Shortcut     | Action               |
| ------------ | -------------------- |
| `SUPER + ,`  | Emoji picker         |
| `SUPER + .`  | Glyph/symbol picker  |
| `SUPER + /`  | Keybinding help menu |
| `SUPER + F1` | Show all keybindings |

### Window Management

| Shortcut            | Action                   |
| ------------------- | ------------------------ |
| `SUPER + Q`         | Close focused window     |
| `SUPER + F`         | Toggle fullscreen        |
| `SUPER + SHIFT + F` | Toggle floating          |
| `SUPER + ;`         | Toggle split direction   |
| `SUPER + G`         | Toggle window group      |
| `SUPER + W`         | Toggle Waybar visibility |

### Focus Navigation

| Shortcut      | Action              |
| ------------- | ------------------- |
| `SUPER + ←/H` | Focus window left   |
| `SUPER + →/L` | Focus window right  |
| `SUPER + ↑/K` | Focus window up     |
| `SUPER + ↓/J` | Focus window down   |
| `ALT + TAB`   | Cycle focus forward |

### Window Resizing

| Shortcut              | Action       |
| --------------------- | ------------ |
| `SUPER + SHIFT + ←/H` | Resize left  |
| `SUPER + SHIFT + →/L` | Resize right |
| `SUPER + SHIFT + ↑/K` | Resize up    |
| `SUPER + SHIFT + ↓/J` | Resize down  |

### Mouse Actions

| Shortcut                     | Action                   |
| ---------------------------- | ------------------------ |
| `SUPER + Left Click + Drag`  | Move window              |
| `SUPER + Right Click + Drag` | Resize window            |
| `SUPER + Z + Drag`           | Move window (keyboard)   |
| `SUPER + X + Drag`           | Resize window (keyboard) |

---

## Workspaces

### Navigation

| Shortcut                   | Action                  |
| -------------------------- | ----------------------- |
| `SUPER + 1-9`              | Switch to workspace 1-9 |
| `SUPER + 0`                | Switch to workspace 10  |
| `SUPER + Mouse Wheel Up`   | Previous workspace      |
| `SUPER + Mouse Wheel Down` | Next workspace          |
| `SUPER + CTRL + ←/H`       | Previous workspace      |
| `SUPER + CTRL + →/L`       | Next workspace          |
| `SUPER + CTRL + ↓/J`       | Next empty workspace    |

### Move Window to Workspace

| Shortcut                     | Action                       |
| ---------------------------- | ---------------------------- |
| `SUPER + SHIFT + 1-9`        | Move window to workspace 1-9 |
| `SUPER + SHIFT + 0`          | Move window to workspace 10  |
| `SUPER + CTRL + SHIFT + ←/H` | Move to previous workspace   |
| `SUPER + CTRL + SHIFT + →/L` | Move to next workspace       |
| `SUPER + CTRL + SHIFT + ↓/J` | Move to empty workspace      |

### Move Window Silently (Stay on Current Workspace)

| Shortcut                   | Action                                |
| -------------------------- | ------------------------------------- |
| `SUPER + ALT + 1-9`        | Move window to workspace 1-9 (silent) |
| `SUPER + ALT + 0`          | Move window to workspace 10 (silent)  |
| `SUPER + CTRL + ALT + ←/H` | Move to previous workspace (silent)   |
| `SUPER + CTRL + ALT + →/L` | Move to next workspace (silent)       |

### Special Workspace (Scratchpad)

| Shortcut            | Action                             |
| ------------------- | ---------------------------------- |
| `SUPER + S`         | Toggle scratchpad visibility       |
| `SUPER + SHIFT + S` | Move window to scratchpad          |
| `SUPER + ALT + S`   | Move window to scratchpad (silent) |

---

## Screen Capture

| Shortcut            | Action                                 |
| ------------------- | -------------------------------------- |
| `SUPER + P`         | Screenshot selection (with annotation) |
| `SUPER + CTRL + P`  | Screenshot entire screen               |
| `SUPER + SHIFT + P` | Color picker (hyprpicker)              |
| `SUPER + ALT + P`   | Screenshot current monitor             |
| `Print`             | Screenshot all monitors                |

---

## System Actions

### Session

| Shortcut              | Action                 |
| --------------------- | ---------------------- |
| `CTRL + ALT + Delete` | Logout menu (wlogout)  |
| `CTRL + ALT + L`      | Lock screen (hyprlock) |

### Wallpaper

| Shortcut            | Action           |
| ------------------- | ---------------- |
| `SUPER + SHIFT + W` | Rotate wallpaper |

---

## Hardware Controls

### Volume

| Shortcut                               | Action                 |
| -------------------------------------- | ---------------------- |
| `SUPER + F12` / `XF86AudioRaiseVolume` | Volume up              |
| `SUPER + F11` / `XF86AudioLowerVolume` | Volume down            |
| `SUPER + F10` / `XF86AudioMute`        | Toggle mute            |
| `XF86AudioMicMute`                     | Toggle microphone mute |

### Brightness

| Shortcut                | Action                      |
| ----------------------- | --------------------------- |
| `XF86MonBrightnessUp`   | Increase screen brightness  |
| `XF86MonBrightnessDown` | Decrease screen brightness  |
| `XF86KbdBrightnessUp`   | Increase keyboard backlight |
| `XF86KbdBrightnessDown` | Decrease keyboard backlight |

### Media Controls

| Shortcut              | Action           |
| --------------------- | ---------------- |
| `XF86AudioPlay/Pause` | Play/pause media |
| `XF86AudioNext`       | Next track       |
| `XF86AudioPrev`       | Previous track   |

---

## Application-Specific Keybindings

These are centrally defined in [home/keybindings/local.nix](../home/keybindings/local.nix) and automatically applied to configured applications.

### Tab Management (Universal)

Works in: Firefox, Kitty, VSCode, Yazi

| Shortcut             | Action            |
| -------------------- | ----------------- |
| `CTRL + T`           | New tab           |
| `CTRL + W`           | Close tab         |
| `CTRL + TAB`         | Next tab          |
| `CTRL + SHIFT + TAB` | Previous tab      |
| `CTRL + SHIFT + T`   | Reopen closed tab |
| `ALT + 1-9`          | Jump to tab 1-9   |

### Editing (Universal)

Works in most text editors and applications:

| Shortcut           | Action           |
| ------------------ | ---------------- |
| `CTRL + S`         | Save             |
| `CTRL + Z`         | Undo             |
| `CTRL + SHIFT + Z` | Redo             |
| `CTRL + X`         | Cut              |
| `CTRL + C`         | Copy             |
| `CTRL + V`         | Paste            |
| `CTRL + A`         | Select all       |
| `CTRL + F`         | Find             |
| `CTRL + H`         | Find and replace |

### Navigation

| Shortcut      | Action            |
| ------------- | ----------------- |
| `CTRL + ←`    | Previous word     |
| `CTRL + →`    | Next word         |
| `Home`        | Start of line     |
| `End`         | End of line       |
| `CTRL + Home` | Start of document |
| `CTRL + End`  | End of document   |

---

## Application-Specific Details

### Kitty (Terminal)

Pre-configured keybindings work automatically. Press `CTRL + F1` in Kitty to see app-specific shortcuts.

Key features:

- Tab management with `CTRL` modifier
- Split management with `CTRL + SHIFT`
- Scroll with `SHIFT + Page Up/Down`

### Neovim

Keybindings defined in [home/programs/neovim/lua/keybindings.lua](../home/programs/neovim/lua/keybindings.lua).

Access help with `:help` or press `SPACE` for leader key commands.

### VSCode

Keybindings in [home/programs/vscode/keybindings.nix](../home/programs/vscode/keybindings.nix).

Uses standard VSCode shortcuts with consistency tweaks to match other apps.

### Firefox

Most shortcuts are Firefox defaults. Custom keybindings are limited due to Firefox's hardcoded shortcuts, but tab navigation follows the universal scheme where possible.

### Yazi (File Manager)

Press `CTRL + F1` in Yazi or check [home/programs/yazi/](../home/programs/yazi/) for custom mappings.

Key navigation:

- `j/k` - Up/down
- `h/l` - Parent/enter directory
- `Space` - Select files
- `/` - Search

---

## Customizing Keybindings

### Changing Shortcuts

1. **For app shortcuts**, edit [home/keybindings/local.nix](../home/keybindings/local.nix):

```nix
{
  tabs = {
    new = "ctrl+t";      # Change to your preference
    close = "ctrl+w";
  };
}
```

2. **For window manager shortcuts**, edit [home/keybindings/global.nix](../home/keybindings/global.nix):

```nix
"$mainMod, T, [Launcher|Apps] terminal, exec, $TERMINAL"
# Change 'T' to your preferred key
```

3. **Rebuild:**

```bash
homeswitch
```

Changes apply automatically to **all configured applications**!

### Adding New Shortcuts

See [USAGE.md#adding-keybinding-support](USAGE.md#adding-keybinding-support) for how to add keybindings to new applications.

---

## Keybinding Conflicts

HyprForge's keybinding philosophy minimizes conflicts:

- **SUPER** - Reserved for window manager (Hyprland)
- **CTRL** - Application shortcuts (mostly consistent across apps)
- **ALT** - Quick actions (ALT+1-9 for tab switching)

If you experience conflicts:

1. Check which app is intercepting the shortcut
2. Modify in the appropriate file (local.nix or global.nix)
3. Rebuild with `homeswitch`

---

## Quick Reference Card

Print this for your desk:

```
╔════════════════════════════════════════════════════════════╗
║              HyprForge Quick Reference                      ║
╠════════════════════════════════════════════════════════════╣
║ SUPER + T        Terminal      │  SUPER + Q      Close     ║
║ SUPER + A        Launcher      │  SUPER + F      Fullscreen║
║ SUPER + E        Files         │  SUPER + 1-9    Workspace ║
║ SUPER + B        Browser       │  SUPER + ←→↑↓   Focus     ║
║ SUPER + ,        Emoji         │  SUPER + SHIFT  Resize    ║
║ SUPER + F1       Help          │  CTRL + ALT + L Lock      ║
╠════════════════════════════════════════════════════════════╣
║ Universal App Shortcuts:                                   ║
║ CTRL + T         New Tab       │  CTRL + W       Close Tab ║
║ CTRL + TAB       Next Tab      │  ALT + 1-9      Jump Tab  ║
║ CTRL + S         Save          │  CTRL + F       Find      ║
╚════════════════════════════════════════════════════════════╝
```

---

## Interactive Help

The best way to learn keybindings:

1. **Press `SUPER + F1`** - Global keybindings menu
2. **Press `CTRL + F1`** - App-specific shortcuts (in supported apps)
3. **Use the search** - Type to filter shortcuts

Both menus are searchable and categorized!

---

## Tips

- **Use the help menu** (`SUPER + F1`) when learning
- **Stick to defaults** initially - they're well thought out
- **Customize gradually** - Change shortcuts as you find friction
- **Keep a cheat sheet** - Print the quick reference above
- **Use Vim keys** (HJKL) - They work throughout the system
- **Arrow keys work too** - If you prefer them over HJKL

---

For more information:

- [USAGE.md](USAGE.md) - How to customize keybindings
- [ARCHITECTURE.md](ARCHITECTURE.md) - How the keybinding system works
- [home/keybindings/](../home/keybindings/) - Source keybinding definitions
