pushd ~/HyprForge >/dev/null || return 0
find . -name '*.nix' -print0 | xargs -0 -- nixpkgs-fmt || truenixpkgs-fmt **/*.nix || true
if command -v prettier >/dev/null 2>&1; then
    prettier --write . || true
fi
popd >/dev/null || true
