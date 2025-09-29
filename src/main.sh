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
: "${OUT_DIR:=${OUT_DIR:-out}}"

log() {
  local lvl="$1"; shift
  echo "$(date --iso-8601=seconds) [$lvl] $*" | tee -a "$OUT_DIR/server.log"
}

if [[ -z "$PORT" ]] || ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
    log ERROR "PORT inválido ($PORT)"
    exit 1
fi

for cmd in nc curl dig jq bats; do
    if ! command -v "$cmd" &> /dev/null; then
        log ERROR "Dependencia '$cmd' no encontrada"
        exit 2
    fi
done

cleanup() {
    log INFO "Apagando servidor en puerto $PORT..."
    rm -f /tmp/tempfile
}
trap cleanup EXIT INT TERM

if ss -tan | grep -q ":$PORT "; then
    log ERROR "Puerto $PORT en uso"
    exit 3
fi

if ! dig +short google.com > /dev/null; then
    log ERROR "Fallo en resolución DNS"
    exit 4
fi

if ! curl -Is https://google.com > /dev/null; then
    log ERROR "Fallo en conexión TLS/HTTPS"
    exit 5
fi

run_collector() {
    if [ -z "${TARGETS:-}" ]; then
        log ERROR "TARGETS no definido"
        exit 1
    fi

    COLLECTOR="$(dirname "$0")/collector.sh"
    OUT_FILE="$OUT_DIR/raw-headers.csv"
    if [ ! -x "$COLLECTOR" ]; then
        log ERROR "Falta $COLLECTOR o no es ejecutable"
        exit 1
    fi

    log INFO "Iniciando collector para TARGETS='$TARGETS' -> $OUT_FILE"
    bash "$COLLECTOR" "$TARGETS" "$OUT_FILE"
    log INFO "Collector finalizado. Resultado: $OUT_FILE"
}

run_health_server() {
    log INFO "Servidor health escuchando en puerto $PORT"
    while true; do
        {
            if ! read -r request; then
                printf 'HTTP/1.1 400 Bad Request\r\nContent-Type: text/plain\r\n\r\nBad Request'
                continue
            fi

            log DEBUG "Petición: $request"
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

