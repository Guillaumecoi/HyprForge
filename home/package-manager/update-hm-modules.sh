#!/usr/bin/env bash
# Update the list of Home Manager modules from GitHub

set -euo pipefail

SCRIPT_DIR="$(dirname "$0")"
PROGRAMS_FILE="$SCRIPT_DIR/hm-programs.json"
SERVICES_FILE="$SCRIPT_DIR/hm-services.json"
MISC_FILE="$SCRIPT_DIR/hm-misc.json"

echo "Fetching Home Manager modules from GitHub..."

# Fetch programs (for programs.*)
curl -s "https://api.github.com/repos/nix-community/home-manager/contents/modules/programs" \
  | jq -r '.[] | select((.type == "file" and (.name | endswith(".nix"))) or .type == "dir") | .name | sub("\\.nix$"; "")' \
  | jq -R -s 'split("\n") | map(select(length > 0 and . != "default"))' \
  > "$PROGRAMS_FILE"

# Fetch services (for services.*)
curl -s "https://api.github.com/repos/nix-community/home-manager/contents/modules/services" \
  | jq -r '.[] | select((.type == "file" and (.name | endswith(".nix"))) or .type == "dir") | .name | sub("\\.nix$"; "")' \
  | jq -R -s 'split("\n") | map(select(length > 0 and . != "default"))' \
  > "$SERVICES_FILE"

# Fetch misc modules (for top-level like gtk, fontconfig, etc.)
curl -s "https://api.github.com/repos/nix-community/home-manager/contents/modules/misc" \
  | jq -r '.[] | select((.type == "file" and (.name | endswith(".nix"))) or .type == "dir") | .name | sub("\\.nix$"; "")' \
  | jq -R -s 'split("\n") | map(select(length > 0 and . != "default" and . != "lib"))' \
  > "$MISC_FILE"

echo "✓ Updated module lists:"
echo "  - Programs: $(jq 'length' "$PROGRAMS_FILE") modules"
echo "  - Services: $(jq 'length' "$SERVICES_FILE") modules"
echo "  - Misc: $(jq 'length' "$MISC_FILE") modules"
