#!/bin/bash

show_help() {
  echo ""
  echo "TP Computacion Aplicada | 2025"
  echo "Este script fue creado con el fin de poder generar el backup de un directorio especifico y guardarlo  dentro de '/backup_dir'"
  echo ""
  echo ""
  echo "Opciones:"
  echo "  -o, --origen   Directorio origen a backupear"
  echo "  -d, --destino  Directorio destino donde guardar el backup"
  echo "  -h, --help"
  echo ""
  echo "Ejemplo:"
  echo "  $0 -o /var/log -d /backup_dir"
}

# Validar argumentos
if [ $# -eq 0 ]; then
  show_help
  exit 1
fi

while [[ "$#" -gt 0 ]]; do
  case $1 in
    -o|--origen)
      ORIGEN="$2"
      shift 2
      ;;
    -d|--destino)
      DESTINO="$2"
      shift 2
      ;;
    -h|--help)
      show_help
      exit 0
      ;;
    *)
      echo "Opcion invalida: $1"
      show_help
      exit 1
      ;;
  esac
done

# Validar que existan los directorios origen y destino
if [ ! -d "$ORIGEN" ]; then
  echo "Error: Directorio origen '$ORIGEN' no existe."
  exit 1
fi

# Si norecibimos  DESTINO, usamos /backup_dir por default
if [ -z "$DESTINO" ]; then
  echo "Directorio destino no especificado, utilizando '/backup_dir' x defecto."
  DESTINO="/backup_dir"
fi

# validamos qeu exista
if [ ! -d "$DESTINO" ]; then
  echo "Error: Directorio destino '$DESTINO' no existe."
  exit 1
fi

# Validar que las rutas existan y esten montadas
if ! mountpoint -q "$ORIGEN"; then
  echo "Error: Origen '$ORIGEN' no es un punto de montaje, verificar disponibilidad."
fi

if ! mountpoint -q "$DESTINO"; then
  echo "Error: El destino '$DESTINO' no esta? montado o no exsite."
  exit 1
fi

# Crear nombre archivo con fecha (YYYYMMDD)
FECHA=$(date +%Y%m%d)

# Extraer nombre 
BASE_NAME=$(basename "$ORIGEN")
ARCHIVO="${BASE_NAME}_bkp_${FECHA}.tar.gz"

# Crear backup
tar -czf "${DESTINO}/${ARCHIVO}" -C "$(dirname "$ORIGEN")" "$BASE_NAME"

if [ $? -eq 0 ]; then
  echo "Backup creado exitosamente: ${DESTINO}/${ARCHIVO}"
else
  echo "Error al crear el backup."
  exit 1
fi
