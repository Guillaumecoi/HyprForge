#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<EOF
Usage: ${0##*/} [-i] [file...]

Replaces TAB characters with two spaces.
- If files are provided and -i is given, files are modified in-place.
- If files are provided without -i, output is printed to stdout.
- If no files are provided, reads from stdin and writes to stdout.
EOF
  exit 2
}

inplace=0
while getopts "ih" opt; do
  case "$opt" in
    i) inplace=1 ;;
    h) usage ;;
    *) usage ;;
  esac
done
shift $((OPTIND-1))

replace_pipe() {
  sed $'s/\t/  /g'
}

if [[ $# -eq 0 ]]; then
  replace_pipe
  exit 0
fi

for f in "$@"; do
  if [[ ! -e "$f" ]]; then
    printf "[warn] file not found: %s\n" "$f" >&2
    continue
  fi
  if [[ $inplace -eq 1 ]]; then
    tmpfile=$(mktemp "${f}.XXXXXX")
    if replace_pipe < "$f" > "$tmpfile"; then
      mv "$tmpfile" "$f"
    else
      rm -f "$tmpfile"
      printf "[error] failed to process: %s\n" "$f" >&2
      exit 1
    fi
  else
    printf "--- %s ---\n" "$f"
    replace_pipe < "$f"
  fi
done
