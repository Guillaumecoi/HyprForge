# Keybinding converter functions
# Transform canonical format "modifier+key" to app-specific formats
{ lib }:

{
  # Kitty format: "ctrl+t" -> "ctrl+t" (mostly same)
  toKitty = key: lib.toLower key;

  # Yazi format: "ctrl+t" -> "<C-t>", "alt+1" -> "<A-1>", "shift+tab" -> "<S-Tab>"
  toYazi =
    key:
    let
      parts = lib.splitString "+" (lib.toLower key);
      convertMod =
        mod:
        if mod == "ctrl" then
          "C"
        else if mod == "alt" then
          "A"
        else if mod == "shift" then
          "S"
        else if mod == "super" then
          "D"
        else
          mod;
      convertKey =
        k:
        if k == "tab" then
          "Tab"
        else if k == "enter" then
          "Enter"
        else if k == "escape" || k == "esc" then
          "Esc"
        else if k == "space" then
          "Space"
        else if k == "backspace" then
          "Backspace"
        else if k == "delete" then
          "Delete"
        else if k == "backtick" || k == "grave" then
          "\`"
        else if lib.hasPrefix "f" k && builtins.stringLength k <= 3 then
          lib.toUpper k
        else
          k;
      numParts = builtins.length parts;
      modifiers = lib.take (numParts - 1) parts;
      finalKey = convertKey (lib.last parts);
      modString = lib.concatMapStringsSep "-" convertMod modifiers;
    in
    if numParts == 1 then "<${finalKey}>" else "<${modString}-${finalKey}>";

  # Neovim/Lua format: same as Yazi
  toNeovim =
    key:
    let
      parts = lib.splitString "+" (lib.toLower key);
      convertMod =
        mod:
        if mod == "ctrl" then
          "C"
        else if mod == "alt" then
          "A"
        else if mod == "shift" then
          "S"
        else if mod == "super" then
          "D"
        else
          mod;
      convertKey =
        k:
        if k == "tab" then
          "Tab"
        else if k == "enter" then
          "Enter"
        else if k == "escape" || k == "esc" then
          "Esc"
        else if k == "space" then
          "Space"
        else if k == "backspace" then
          "Backspace"
        else if k == "delete" then
          "Delete"
        else if k == "backtick" || k == "grave" then
          "\`"
        else if lib.hasPrefix "f" k && builtins.stringLength k <= 3 then
          lib.toUpper k
        else
          k;
      numParts = builtins.length parts;
      modifiers = lib.take (numParts - 1) parts;
      finalKey = convertKey (lib.last parts);
      modString = lib.concatMapStringsSep "-" convertMod modifiers;
    in
    if numParts == 1 then "<${finalKey}>" else "<${modString}-${finalKey}>";

  # VSCode format: "ctrl+t" -> "ctrl+t" (same format)
  toVscode = key: lib.toLower key;

  # Hyprland format: "ctrl+t" -> "CTRL, T"
  toHyprland =
    key:
    let
      parts = lib.splitString "+" (lib.toLower key);
      numParts = builtins.length parts;
      modifiers = lib.take (numParts - 1) parts;
      finalKey = lib.last parts;
      convertMod =
        mod:
        if mod == "ctrl" then
          "CTRL"
        else if mod == "alt" then
          "ALT"
        else if mod == "shift" then
          "SHIFT"
        else if mod == "super" then
          "$mainMod"
        else
          lib.toUpper mod;
      modString = lib.concatMapStringsSep " " convertMod modifiers;
    in
    "${modString}, ${lib.toUpper finalKey}";

  # Firefox/Vimium format: "ctrl+t" -> "<c-t>", "alt+1" -> "<a-1>"
  # Vimium uses angle brackets and lowercase modifiers
  toFirefox =
    key:
    let
      parts = lib.splitString "+" (lib.toLower key);
      convertMod =
        mod:
        if mod == "ctrl" then
          "c"
        else if mod == "alt" then
          "a"
        else if mod == "shift" then
          "s"
        else if mod == "super" then
          "m"
        else
          mod;
      convertKey =
        k:
        if k == "tab" then
          "tab"
        else if k == "enter" then
          "enter"
        else if k == "escape" || k == "esc" then
          "esc"
        else if k == "space" then
          "space"
        else if k == "backspace" then
          "backspace"
        else if k == "delete" then
          "delete"
        else if k == "backtick" || k == "grave" then
          "`"
        else if k == "backslash" then
          "\\\\"
        else if k == "slash" then
          "/"
        else if k == "equal" then
          "="
        else if k == "plus" then
          "+"
        else if k == "minus" then
          "-"
        else if k == "left" then
          "left"
        else if k == "right" then
          "right"
        else if k == "up" then
          "up"
        else if k == "down" then
          "down"
        else if k == "[" then
          "["
        else if k == "]" then
          "]"
        else if lib.hasPrefix "f" k && builtins.stringLength k <= 3 then
          k
        else
          k;
      numParts = builtins.length parts;
      modifiers = lib.take (numParts - 1) parts;
      finalKey = convertKey (lib.last parts);
      modString = lib.concatMapStringsSep "-" convertMod modifiers;
    in
    if numParts == 1 then finalKey else "<${modString}-${finalKey}>";
}
