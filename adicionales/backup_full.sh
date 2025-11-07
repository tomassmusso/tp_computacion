#!/bin/bash
# ------------------------------------------------------------
# Script: backup_full.sh
# Descripción: Genera un backup comprimido de un directorio.
# Uso: ./backup_full.sh <origen> <destino>
# ------------------------------------------------------------

# --- Mostrar ayuda ---
if [ "$1" = "-help" ] || [ $# -lt 2 ]; then
    echo "Uso: $0 <directorio_origen> <directorio_destino>"
    echo "Ejemplo: $0 /var/log /backup_dir"
    exit 1
fi

ORIGEN=$1
DESTINO=$2
FECHA=$(date +%Y%m%d)

# --- Validar que existan origen y destino ---
if [ ! -d "$ORIGEN" ]; then
    echo "Error: el directorio de origen '$ORIGEN' no existe."
    exit 1
fi

if [ ! -d "$DESTINO" ]; then
    echo "Error: el directorio de destino '$DESTINO' no existe."
    exit 1
fi

# --- Crear nombre del backup ---
NOMBRE=$(basename "$ORIGEN")_bkp_${FECHA}.tar.gz
RUTA_FINAL="$DESTINO/$NOMBRE"

# --- Generar backup ---
tar -czf "$RUTA_FINAL" "$ORIGEN"

# --- Confirmación ---
if [ $? -eq 0 ]; then
    echo "Backup creado correctamente: $RUTA_FINAL"
else
    echo "Error al generar el backup."
fi
