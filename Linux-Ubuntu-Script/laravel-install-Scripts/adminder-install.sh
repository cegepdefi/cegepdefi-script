#!/bin/bash

# Accede a la interfaz web de Adminer desde tu navegador usando la URL: ip:/adminer

# Para executar y que responda "YES" a cualquier pregunta usar:
# yes | sudo sh adminder-install.sh

# Actualiza los paquetes del sistema con el comando
sudo apt update

# Instala Adminer con el comando:
# adminer es como phpmyadmin "Lo tengo que usar porque phpmyadmin no es compatible con PHP8>"
sudo apt install adminer -y

# Habilita la configuración de Adminer con el comando
sudo a2enconf adminer

# systemctl
sudo systemctl restart apache2
sudo systemctl enable apache2

# Firewall
sudo ufw allow 'Apache Full'
# sudo ufw enable

# Desactivo el firewall porque necesito el SSH para comando + Filezilla
sudo ufw disable

# sudo ufw status

#--
# También debes asegurarte de que el servidor de base de datos (MySQL o MariaDB) 
# permita la conexión remota desde otras direcciones IP. Puedes hacerlo editando 
# el archivo /etc/mysql/my.cnf y cambiando la línea bind-address = 127.0.0.1 
# por bind-address = 0.0.0.0 o por la dirección IP específica que quieras permitir12.
#--
