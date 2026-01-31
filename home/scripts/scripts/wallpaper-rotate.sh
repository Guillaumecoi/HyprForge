#!/usr/bin/env bash
set -euo pipefail

# Look in per-user `local` first, then nix-provided `nix`, then fallback to Pictures/Wallpapers
WALLPAPER_DIRS=(
  "${HOME}/Pictures/Wallpapers/local"
  "${HOME}/Pictures/Wallpapers/nix"
)

# Collect wallpapers from existing dirs
WALLPAPERS=()
for dir in "${WALLPAPER_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    # resolve symlinked directories (some systems don't let find follow the symlink path)
    target_dir=$(readlink -f "$dir" 2>/dev/null || printf '%s' "$dir")
    if [ -d "$target_dir" ]; then
      while IFS= read -r -d $'\0' file; do
        WALLPAPERS+=("$file")
      done < <(find -L "$target_dir" -type f \( -iname "*.png" -o -iname "*.jpg" -o -iname "*.jpeg" \) -print0)
    fi
  fi
done

# Check if any wallpapers found
if [ ${#WALLPAPERS[@]} -eq 0 ]; then
  echo "Error: No wallpaper files found in ${WALLPAPER_DIRS[*]}"
  exit 1
fi

# Select random wallpaper
RANDOM_INDEX=$(($RANDOM % ${#WALLPAPERS[@]}))
SELECTED_WALLPAPER="${WALLPAPERS[$RANDOM_INDEX]}"

echo "Setting wallpaper to: $(basename "$SELECTED_WALLPAPER")"

# Set wallpaper using swww
if command -v swww >/dev/null 2>&1; then
  # Check if swww daemon is responding, start it if not
  if ! swww query >/dev/null 2>&1; then
    echo "Starting swww daemon..."
    swww-daemon &
    sleep 1  # Give daemon time to start
  fi

  swww img "$SELECTED_WALLPAPER" --transition-type grow --transition-pos center --transition-duration 2
else
  echo "Error: swww not found"
  exit 1
fi
