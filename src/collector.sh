#!/usr/bin/env bash
set -euo pipefail
TARGETS_RAW="${1:-}"
OUT_FILE="${2:-out/raw-headers.csv}"
mkdir -p "$(dirname "$OUT_FILE")"
echo "endpoint,header,valor" > "$OUT_FILE"
IFS=',' read -r -a TARGETS <<< "$TARGETS_RAW"
for t in "${TARGETS[@]}"; do
  t="$(echo "$t" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"
  [ -z "$t" ] && continue
  echo "$t,Mock-Header,MockValue" >> "$OUT_FILE"
done
