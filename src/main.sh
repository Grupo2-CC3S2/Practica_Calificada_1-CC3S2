#!/usr/bin/env bash
set -euo pipefail

echo "servidor simple con el puerto $PORT"
while true; do
    echo -e "HTTP/1.1 200 OK\n\n$MESSAGE" | nc -l -p "$PORT"
done