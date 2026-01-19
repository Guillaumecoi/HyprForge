{ pkgs, ... }:

let
  scriptsDir = ./scripts;
  entries = builtins.attrNames (builtins.readDir scriptsDir);
  shFiles = builtins.filter (f: builtins.match ".*\\.sh" f != null) entries;

  mkScript = file:
    let
      name = builtins.replaceStrings [ ".sh" ] [ "" ] file;
      src = builtins.readFile ("${scriptsDir}/${file}");
    in
    pkgs.writeShellScriptBin name src;

  pyFiles = builtins.filter (f: builtins.match ".*\\.py" f != null) entries;

  mkPyScript = file:
    let
      name = builtins.replaceStrings [ ".py" ] [ "" ] file;
      src = builtins.readFile ("${scriptsDir}/${file}");
      pythonEnv = pkgs.python313.withPackages (ps: with ps; [ grequests ]);
      wrapper = ''
        #!/bin/sh
        exec ${pythonEnv}/bin/python - "$@" <<'PY'
        ${src}
        PY
      '';
    in
    pkgs.writeShellScriptBin name wrapper;

  scripts = (map mkScript shFiles) ++ (map mkPyScript pyFiles);
in

{
  home.packages = scripts;
}
