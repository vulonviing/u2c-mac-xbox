#!/bin/bash
# READ-ONLY: compares a file's SHA-256 with known official values. Does not modify the file.
# Usage: bash scripts/verify-sha256.sh <file> [--show]
# Comparing per-unit full-flash dumps is MEANINGLESS (every device differs); this is for the official .dat.
set -eu
[ "${1:-}" = "--help" ] || [ $# -lt 1 ] && { sed -n '2,5p' "$0"; exit 0; }
H=$(shasum -a 256 "$1" | cut -d' ' -f1)
case "$H" in
  87349e603bb92d6ae9ff6defb6f32b10de2f2d3252fe4e442fa7993f982f2a5a) echo "match: official controller firmware 1.09 .dat" ;;
  *) echo "unknown: does not match any known official value" ;;
esac
[ "${2:-}" = "--show" ] && echo "$H"
exit 0
