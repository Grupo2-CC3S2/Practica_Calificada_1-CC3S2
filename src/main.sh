#!/usr/bin/env bash
set -euo pipefail

#Variables de entorno con valores por defecto
: "${PORT:=${1:-8080}}"
: "${MESSAGE:="La aplicación está funcionando en el puerto"}"

# Función de limpieza
cleanup() {
    echo "Apagando servidor en puerto $PORT..."
}
trap cleanup EXIT INT TERM


echo "servidor simple con el puerto $PORT"
while true; do
    echo -e "HTTP/1.1 200 OK\n\n$MESSAGE" | nc -l -p "$PORT"
    echo "================================"
done