#!/bin/bash

# chmod +x my_clean_externalDisk.sh
# ./my_clean_externalDisk.sh

read -p "Introduce el punto de montaje del volumen (ej. /mnt/external): " volume

echo "Optimización del volumen en $volume..."
rm -rf $volume/tmp/*
echo "Limpiando cachés..."
sync; echo 3 > /proc/sys/vm/drop_caches
echo "Eliminando archivos grandes de registro..."
find $volume/logs -type f -size +10M -delete

echo "Espacio libre antes y después de la optimización:"
df -h $volume > clean.log
echo "Optimización completada. Los resultados están en clean.log."
