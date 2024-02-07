#!/bin/bash


# -----------------------------------------------
# Comando desde el cliente para vulnerabilidad del encabezado "X-Forwarded-For"

# cliente usando el server proxy:
# curl -x http://ipServerProxy:80 -I --header "X-Forwarded-For: 8.8.8.8" --header "Cache-Control: no-cache" http://ipServerApache

# Sin el proxy:
# curl -I --header "X-Forwarded-For: 8.8.8.8" --header "Cache-Control: no-cache" http://ipServerApache

# Ese comando se supone que debe hacer que en el log del
# servidor apache aparesca la ip 8.8.8.8 y no la del cliente incluso si el cliente usa VPN.

# ***El resultado normal es el siguiente desde el lado del cliente:
# HTTP/1.1 200 OK
# Date: Sun, 17 Sep 2023 00:27:17 GMT
# Server: Apache/2.4.54 (Ubuntu)
# Link: <http://10.0.0.14/index.php?rest_route=/>; rel="https://api.w.org/"
# Content-Type: text/html; charset=UTF-8

# No es bueno dejar que se sepa "Server: Apache/2.4.54 (Ubuntu)"
# -----------------------------------------------



# -----------------------------------------------
# Comando desde el serve Apache para ver las ip que contactaron con el server:
# cat /var/log/apache2/access.log
# -----------------------------------------------


# -----------------------------------------------
echo "Hacer que no se vea la version de apache y de Linux"

# hacer backup del archivo
sudo cp /etc/apache2/conf-available/security.conf /etc/apache2/conf-available/security.conf.back1

# modificar achivo para esconder version de apache
sudo echo "ServerTokens Prod" > /etc/apache2/conf-available/security.conf
sudo echo "ServerSignature On" >> /etc/apache2/conf-available/security.conf
sudo echo "TraceEnable Off" >> /etc/apache2/conf-available/security.conf

# Ahora el resultado del cliente sera: "Server: Apache".
# y NO "Server: Apache/2.4.54 (Ubuntu)".
# -----------------------------------------------


sudo systemctl restart apache2