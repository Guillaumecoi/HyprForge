#!/usr/bin/env bash
set -euo pipefail
# Format .nix files in the current directory tree, and run prettier if available.
if command -v nixpkgs-fmt >/dev/null 2>&1; then
    find . -type f -name '*.nix' -print0 | xargs -0 -r nixpkgs-fmt || true
elif command -v truenixpkgs-fmt >/dev/null 2>&1; then
    find . -type f -name '*.nix' -print0 | xargs -0 -r truenixpkgs-fmt || true
else
    echo "No nix formatter found; skipping .nix formatting" >&2
fi

if command -v prettier >/dev/null 2>&1; then
    prettier --write . || true
fi

exit 0
