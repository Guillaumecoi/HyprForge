#!/usr/bin/env bash
set -euo pipefail

# Restore brightness from the saved runtime file written by
# hypridle-save-and-dim.sh and remove the file.

RUNDIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
SAVE_FILE="$RUNDIR/hypridle-brightness"

if [ -f "$SAVE_FILE" ]; then
  val=$(cat "$SAVE_FILE")
  if command -v brightnessctl >/dev/null 2>&1; then
    brightnessctl set "$val" >/dev/null 2>&1 || true
  else
    # Try sysfs fallback: set proportional value if possible
    for d in /sys/class/backlight/*; do
      [ -f "$d/brightness" ] || continue
      max=$(cat "$d/max_brightness")
      pct=${val%%%} # strip trailing %
      target=$(( max * pct / 100 ))
      printf "%d" "$target" > "$d/brightness" 2>/dev/null || true
    done
  fi
  rm -f "$SAVE_FILE"
fi

exit 0
