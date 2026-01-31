#!/usr/bin/env bash
set -euo pipefail

# Save current brightness as a percent and dim the screen, then notify that
# the screen will be locked in 60s.

RUNDIR="${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
SAVE_FILE="$RUNDIR/hypridle-brightness"

get_brightness_percent() {
  if command -v brightnessctl >/dev/null 2>&1; then
    CUR=$(brightnessctl g)
    MAX=$(brightnessctl m)
    if [ -n "$CUR" ] && [ -n "$MAX" ] && [ "$MAX" -ne 0 ]; then
      PCT=$(( CUR * 100 / MAX ))
      printf "%s%%" "$PCT"
      return 0
    fi
  fi

  # Fallback to sysfs
  for d in /sys/class/backlight/*; do
    [ -f "$d/brightness" ] || continue
    cur=$(cat "$d/brightness")
    max=$(cat "$d/max_brightness")
    [ -n "$cur" ] && [ -n "$max" ] && [ "$max" -ne 0 ] || continue
    pct=$(( cur * 100 / max ))
    printf "%s%%" "$pct"
    return 0
  done

  return 1
}

if pct=$(get_brightness_percent); then
  printf "%s" "$pct" > "$SAVE_FILE"
fi

# Decide dim target: if original brightness was 10% or lower, set 0%, else 10%
target="10%"
if [ -n "${pct-}" ]; then
  pctnum=${pct%%%}
  if echo "$pctnum" | grep -Eq '^[0-9]+$' && [ "$pctnum" -le 10 ]; then
    target="0%"
  fi
fi

# Dim the screen
if command -v brightnessctl >/dev/null 2>&1; then
  brightnessctl set "$target" >/dev/null 2>&1 || true
else
  # Sysfs fallback
  pctnum=${target%%%}
  for d in /sys/class/backlight/*; do
    [ -f "$d/brightness" ] || continue
    max=$(cat "$d/max_brightness")
    targetval=$(( max * pctnum / 100 ))
    printf "%d" "$targetval" > "$d/brightness" 2>/dev/null || true
  done
fi

# Send a one-minute warning notification (prefer dunstify for dunst)
if command -v dunstify >/dev/null 2>&1; then
  dunstify -u normal -t 60000 "Screen will be locked in 1 minute" || true
elif command -v notify-send >/dev/null 2>&1; then
  notify-send -u normal -t 60000 "Screen will be locked in 1 minute" || true
fi

exit 0
