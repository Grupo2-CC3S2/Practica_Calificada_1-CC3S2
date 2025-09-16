#!/usr/bin/env bash
set -euo pipefail

########################################
# Script: procesos.sh
# Códigos de salida:
# 0 = éxito
# 1 = error de señal inesperada
########################################

running=true

# función de limpieza
cleanup() {
    echo "Proceso detenido (PID $$)"
    running=false
}
trap cleanup INT TERM

echo "Iniciando proceso simulado (PID $$)..."
counter=0

# loop infinito simulado
while $running; do
    counter=$((counter+1))
    echo "Iteración $counter (PID $$)"
    sleep 3
done

echo "Proceso finalizado correctamente"
exit 0
