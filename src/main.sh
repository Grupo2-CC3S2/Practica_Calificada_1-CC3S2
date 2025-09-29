#!/usr/bin/env bash
set -euo pipefail

ENV_FILE="$(dirname "$0")/../.env"
if [ -f "$ENV_FILE" ]; then
  # shellcheck disable=SC1090
  source "$ENV_FILE"
fi

# Variables (prioridad: ARG -> env exportada -> .env defaults)
: "${PORT:=${1:-${PORT:-8080}}}"
: "${MESSAGE:=${MESSAGE:-'La aplicación está funcionando en el puerto'}}"
: "${TARGETS:=${TARGETS:-}}"


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


run_collector() {
    if [ -z "${TARGETS:-}" ]; then
        echo "Error: TARGETS no definido. Edita .env o exporta TARGETS." >&2
        exit 1
    fi

    COLLECTOR="$(dirname "$0")/collector.sh"
    OUT_FILE="out/raw-headers.csv"
    if [ ! -x "$COLLECTOR" ]; then
        echo "Error: falta $COLLECTOR o no es ejecutable. Añade src/collector.sh" >&2
        exit 1
    fi

    echo "Iniciando collector para TARGETS='$TARGETS' -> $OUT_FILE"
    bash "$COLLECTOR" "$TARGETS" "$OUT_FILE"
    echo "Collector finalizado."
}

run_health_server() {
    echo "Servidor health escuchando en puerto $PORT (Ctrl+C para salir)"
    while true; do
        {
            # leer la primera línea de la petición (ej: "GET /salud HTTP/1.1")
            if ! read -r request; then
                printf 'HTTP/1.1 400 Bad Request\r\nContent-Type: text/plain\r\n\r\nBad Request'
                continue
            fi

            echo "Petición: $request" >&2
            if [[ "$request" =~ ^GET\ /salud\  ]]; then
                printf 'HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\nOK'
            else
                printf 'HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\nNot Found'
            fi
        } | nc -l -p "$PORT"
    done
}


case "${1:-}" in
  collect)
    run_collector
    ;;
  server|"")
    run_health_server
    ;;
  *)
    echo "Uso: $0 [collect|server]"
    exit 2
    ;;
esac

