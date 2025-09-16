#!/usr/bin/env bash
set -euo pipefail

#Variables de entorno con valores por defecto
: "${PORT:=${1:-8080}}"
: "${MESSAGE:="La aplicación está funcionando en el puerto"}"
 
if [[ -z "$PORT" ]] || ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
    echo "Error: PORT inválido ($PORT)" >&2
    exit 1
fi

# Verificar dependencias
for cmd in nc curl dig; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: la dependencia '$cmd' no está instalada" >&2
        exit 2
    fi
done

# Función de limpieza
cleanup() {
    echo "Apagando servidor en puerto $PORT..."
    rm -f /tmp/tempfile
}
trap cleanup EXIT INT TERM


if ss -tan | grep -q ":$PORT "; then
    echo "Error: el puerto $PORT ya está en uso" >&2
    exit 3
fi

if ! dig +short google.com > /dev/null; then
    echo "Error: fallo en resolución DNS" >&2
    exit 4
fi

if ! curl -Is https://google.com > /dev/null; then
    echo "Error: fallo en conexión TLS/HTTPS" >&2
    exit 5
fi

echo "servidor simple con el puerto $PORT"
while true; do
    echo -e "HTTP/1.1 200 OK\n\n$MESSAGE" | nc -l -p "$PORT"
    echo "================================"
done