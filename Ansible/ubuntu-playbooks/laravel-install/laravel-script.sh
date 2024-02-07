#!/bin/bash

# Para executar y que responda "YES" a cualquier pregunta usar:
# yes | sudo sh laravel-script.sh

# Para executar comandos que tienen sudo sinponer contra
# echo <password> | sudo -S ./myscript.sh

echo "El primer argumento pasado es $1"
echo "El segundo argumento pasado es $2"

# 1. php 8.1+ ?
# NOTA: no se porque se instalo la version PHP 7.4
# sudo apt install apache2 mysql-server php php-mysql libapache2-mod-php php-gd php-mbstring php-xml php-curl php-zip unzip curl -y

# 2. Descarga e instala Composer:
# curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer

# 3. Verifica la versión de Composer:
# NOTA: me dice "Composer version 2.5.5" VS "PHP 7.4" -> Laravel 9?
composer --version

# 4. Crea una nueva aplicación de Laravel:
# NOTA: ningun error por ahora..
composer create-project --prefer-dist laravel/laravel myapp

# 5. Configura los permisos de la carpeta storage:
#cd myapp
sudo chgrp -R www-data ./myapp/storage ./myapp/bootstrap/cache
sudo chmod -R ug+rwx ./myapp/storage ./myapp/bootstrap/cache


# * 6. Configura el archivo .env para conectar con la base de datos:
cp ./.env.back01 ./myapp/.env
# cp .env.example .env
# nano .env

# *En el archivo .env, configura las variables de conexión a la base de datos
# (DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME, DB_PASSWORD) para que se correspondan con tu configuración.

# ------------------[Configuracion por defecto]--------------------
# DB_CONNECTION=mysql
# DB_HOST=127.0.0.1
# DB_PORT=3306
# DB_DATABASE=laravel
# DB_USERNAME=root
# DB_PASSWORD=
# --------------------------------------------------------------------

# *Aquí puedes modificar la configuración de la base de datos según tu necesidad.
# Por ejemplo, si estás usando una base de datos PostgreSQL en lugar de MySQL, debes cambiar
# DB_CONNECTION a pgsql y ajustar las demás variables en consecuencia.

# Una vez que hayas modificado el archivo .env, deberás guardarlo y salir del editor de texto.
# Luego, ejecuta el siguiente comando para aplicar los cambios: #7

# *Puedes usar el siguiente comando para saber el estado del servicio de la base de datos:
# sudo systemctl status mysql

# *Si quieres entrar a la base de datos usa el comando:
# NOTA: root en mysql por defecto no tiene contraseña, entrar vacio..

# sudo -i
# mysql -u root -p

# *Para cambiar la contraseña de root en mysql conectate en mysql y usa:
# ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin123';

# *Para agregar un nuevo usuario a mysql y que tenga todos los derechos usar:

# CREATE USER 'admin'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin123';
# GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';
# FLUSH PRIVILEGES;

# *Nota: Asegúrate de reemplazar nuevo_usuario con el nombre del nuevo usuario 
# que desees agregar y contraseña_nuevo_usuario con la contraseña que deseas 
# establecer para el nuevo usuario. La cláusula GRANT ALL PRIVILEGES ON *.* otorga
# todos los permisos al usuario en todas las bases de datos y tablas.
# *Sal del shell de MySQL ejecutando exit.

# *hacer un test de conexion de nuevo con el usuario root y admin
# mysql -u admin -p

# *Usando el usuario admin crea una DB con el nombre laravel
# CREATE DATABASE laravel;
# SHOW DATABASES;

# *salir de la conexion mysql y de root y regresar con admin
# *ahora si, modifica el archivo "nano .env" y poner el nombre 
# de usuario admin con la contraseña y la base de datos que creaste "laravel".

# *Executar comando SQL directamente desde la terminal
#sudo mysql -u root -p -e "CREATE DATABASE laravel"

# *Executar comandos SQL que estan en archivo .sql
# *Es mejor usar el archivo .sql asi puedes hacer mas cosas sin error.
echo "--> comando: sudo mysql -u root -p < laravel-mysql.sql"
# sudo mysql -u root -p < laravel-mysql.sql
sudo mysql -u root -p '' < laravel-mysql.sql

# entrar en el folder de la app para poder executar los otros comandos
cd myapp

# * 7. Genera una nueva clave de aplicación:
# aqui me pide pass porque?
echo "--> comando: artisan key:generate"
php artisan key:generate

# * 8. Ejecuta la migración de la base de datos:
# NOTA : Primero tienes que crear una DB con el nombre que pusiste en el archivo ".env"
echo "--> comando: sudo php artisan migrate"
sudo php artisan migrate

# * permitimos el puerto 8000 en el firewall
sudo ufw allow 8000/tcp

# * 9. Ejecuta el servidor de Laravel:
echo "--> comando: php artisan serve"
php artisan serve --host=0.0.0.0

# *Ahora puedes abrir tu navegador web y navegar a http://localhost:8000 para ver tu aplicación de Laravel en funcionamiento.
# *Ten en cuenta que estos pasos son solo una guía general y pueden requerir ajustes adicionales según tu configuración específica.
# ========================================================