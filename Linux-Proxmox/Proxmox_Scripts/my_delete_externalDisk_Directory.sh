#!/bin/bash

# chmod +x my_delete_externalDisk_Directory.sh
# ./my_delete_externalDisk_Directory.sh

read -p "Introduce el directorio principal donde borrar las subcarpetas (ej. /mnt/external): " directory

echo "Eliminando directorios específicos..."
find $directory -type d \( -name "env" -o -name ".env" -o -name "venv" -o -name ".venv" -o -name ".vs" -o -name ".git" -o -name ".github" -o -name "node_modules" \) -exec rm -rf {} +

echo "Directorio eliminado completamente."
