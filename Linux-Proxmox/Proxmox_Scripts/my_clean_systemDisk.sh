#!/bin/bash

# chmod +x my_clean_systemDisk.sh
# ./my_clean_systemDisk.sh

echo "Actualizando el sistema..."
apt update && apt upgrade -y

echo "Limpiando después de la actualización..."
apt autoremove -y && apt autoclean

echo "Optimización del sistema..."
rm -rf /tmp/*
echo "Limpiando cachés..."
sync; echo 3 > /proc/sys/vm/drop_caches
echo "Eliminando archivos grandes de registro..."
find /var/log -type f -size +10M -delete

echo "Espacio libre antes y después de la optimización:"
df -h / > clean.log
echo "Optimización completada. Los resultados están en clean.log."
