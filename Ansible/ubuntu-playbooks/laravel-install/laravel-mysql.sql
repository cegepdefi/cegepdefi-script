-- sudo -i
-- mysql -u root -p

-- *Usando el usuario admin crea una DB con el nombre laravel
-- mysql -u admin -p
CREATE DATABASE laravel;
SHOW DATABASES;

-- *Para agregar un nuevo usuario a mysql y que tenga todos los derechos usar:
CREATE USER 'admin'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin123';
-- GRANT ALL PRIVILEGES ON *.* TO 'admin'@'localhost';
GRANT ALL PRIVILEGES ON laravel.* TO 'admin'@'localhost';
FLUSH PRIVILEGES;

-- *Para cambiar la contraseña de root en mysql conectate en mysql y usa:
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'admin123';