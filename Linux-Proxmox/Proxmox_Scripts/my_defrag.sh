#!/bin/bash

# chmod +x my_defrag.sh
# ./my_defrag.sh

echo "Discos disponibles:"
lsblk -d -o NAME,SIZE

read -p "Introduce el nombre del disco que deseas desfragmentar (ej. sda): " disk

echo "Desfragmentando el disco $disk..."
e4defrag /dev/$disk
echo "Desfragmentación completada."
