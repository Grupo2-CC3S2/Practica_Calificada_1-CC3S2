#!/usr/bin/env bash
set -euo pipefail

########################################
# Códigos de salida:
# 0 = éxito
# 1 = error en comando ss
# 2 = error en procesamiento awk/sed
########################################

OUTPUT="out/conexiones.log"

# validar dependencias
for cmd in ss awk sort uniq tee; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: falta dependencia '$cmd'" >&2
        exit 2
    fi
done

echo "Generando reporte de conexiones activas..."

# capturar conexiones TCP y procesar
if ! ss -tan 2>/dev/null | awk '{print $1, $2, $3}' | sort | uniq -c | tee "$OUTPUT"; then
    echo "Error al generar reporte de conexiones" >&2
    exit 1
fi

echo "Reporte generado en $OUTPUT"
exit 0
