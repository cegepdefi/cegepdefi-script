#!/bin/bash

# Actualiza el sistema
sudo apt update
sudo apt upgrade -y

# Instala Squid
sudo apt install squid -y

# Haz una copia de seguridad del archivo de configuración original
sudo cp /etc/squid/squid.conf /etc/squid/squid.conf.bak

# Edita el archivo de configuración de Squid
# sudo nano /etc/squid/squid.conf

# Dentro del archivo de configuración, puedes personalizar la configuración de Squid según tus necesidades.
# A continuación, se muestra un ejemplo de configuración básica que permite a cualquier cliente en la red local
# utilizar el servidor proxy en el puerto 80. Ajusta la configuración según tus requisitos.

# Configuración básica para permitir el acceso desde la red local
cat <<EOL | sudo tee -a /etc/squid/squid.conf
http_port 80
#acl localnet src 10.0.0.0/24  # Reemplaza esto con tu rango de red local
http_access allow localnet
http_access deny all
EOL

# Reinicia Squid para aplicar la configuración
sudo systemctl restart squid

# Habilita el inicio automático de Squid al arrancar
sudo systemctl enable squid

# Abre el puerto 80 en el cortafuegos si está habilitado
sudo ufw allow 80/tcp

# Muestra el estado de Squid
sudo systemctl status squid

echo "El servidor proxy Squid se ha configurado correctamente en el puerto 80."

# Comando para ver las ip que usan el proxy:
# sudo cat /var/log/squid/access.log

echo "Comando para ver las ip que usan el proxy:"
echo "sudo cat /var/log/squid/access.log"