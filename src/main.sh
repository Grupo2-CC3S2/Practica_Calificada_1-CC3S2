#!/usr/bin/env bash
set -euo pipefail
PORT="${1:-8080}"
MESSAGE="La aplicación está funcionando en el puerto"
echo "servidor simple con el puerto $PORT"
while true; do
    echo -e "HTTP/1.1 200 OK\n\n$MESSAGE" | nc -l -p "$PORT"
    echo "================================"
done