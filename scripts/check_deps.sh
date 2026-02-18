#!/usr/bin/env bash
set -euo pipefail
for c in opencode xelatex quarto Rscript pdf2svg gh; do
  printf "%-10s" "$c:"
  if command -v "$c" >/dev/null 2>&1; then
    echo "OK ($(command -v "$c"))"
  else
    echo "MISSING"
  fi
done
