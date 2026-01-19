#!/usr/bin/env bash
set -euo pipefail

# Save screenshots and open annotation tool from memory (tmpfs) before saving
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

# Use XDG_RUNTIME_DIR if set, otherwise /dev/shm (tmpfs)
TMP_ROOT="${XDG_RUNTIME_DIR:-/dev/shm}"
TMP_DIR="$TMP_ROOT/hyprforge-screenshots"
mkdir -p "$TMP_DIR"

TMPFILE="$TMP_DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"

case "${1:-select}" in
  select)
    # Use wayfreeze to freeze screen if available
    if command -v wayfreeze >/dev/null 2>&1; then
      grim -g "$(wayfreeze --hide-cursor --after-freeze-cmd slurp)" -t png - > "$TMPFILE"
    else
      grim -g "$(slurp)" -t png - > "$TMPFILE"
    fi
    ;;
  full)
    grim -t png - > "$TMPFILE"
    ;;
  *)
    echo "Usage: $0 {select|full}" >&2
    exit 1
    ;;
esac

# If satty is available, open it for annotation (edits are done in-place)
if command -v satty >/dev/null 2>&1; then
  satty --filename "$TMPFILE"
fi

# After annotation (or immediately if no annotator), copy from tmpfs to persistent screenshots
if [ -f "$TMPFILE" ]; then
  FILENAME="$SCREENSHOT_DIR/$(basename "$TMPFILE")"
  cp "$TMPFILE" "$FILENAME"

  # Copy final image to Wayland clipboard if wl-copy is available
  if command -v wl-copy >/dev/null 2>&1; then
    wl-copy < "$TMPFILE"
  fi

  notify-send "Screenshot" "Saved $(basename "$FILENAME") and copied to clipboard." -i "$FILENAME"

  # Clean up tmpfs copy
  rm -f "$TMPFILE"
fi
