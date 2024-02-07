apt update -y
apt autoremove -y


# Link:
# https://www.zabbix.com/download?zabbix=6.0&os_distribution=ubuntu&os_version=22.04&components=server_frontend_agent&db=mysql&ws=apache


#-----------------------
# a. Install Zabbix repository 
apt install wget -y
wget https://repo.zabbix.com/zabbix/6.0/ubuntu/pool/main/z/zabbix-release/zabbix-release_6.0-4+ubuntu22.04_all.deb
dpkg -i zabbix-release_6.0-4+ubuntu22.04_all.deb
#-----------------------


#-----------------------
apt update -y
apt autoremove -y
#-----------------------


#-----------------------
# b. Install Zabbix proxy
apt install mysql-server zabbix-server-mysql zabbix-frontend-php zabbix-apache-conf zabbix-sql-scripts zabbix-agent -y
#-----------------------

#-----------------------
echo "mysql-server mysql-server/root_password password Admin1234" | debconf-set-selections \
    && echo "mysql-server mysql-server/root_password_again password Admin1234" | debconf-set-selections
#-----------------------

#-----------------------
# c. Create initial database
# Make sure you have database server up and running.
# Run the following on your database host. 
mysql -u root -pAdmin1234 -e "create database zabbix character set utf8mb4 collate utf8mb4_bin;"
mysql -u root -pAdmin1234 -e "create user zabbix@localhost identified by 'password';"
mysql -u root -pAdmin1234 -e "grant all privileges on zabbix.* to zabbix@localhost;"
mysql -u root -pAdmin1234 -e "set global log_bin_trust_function_creators = 1;"
#-----------------------

#-----------------------
# On Zabbix server host import initial schema and data. You will be prompted to enter your newly created password.
cat /usr/share/zabbix-sql-scripts/mysql/server.sql.gz | mysql --default-character-set=utf8mb4 -uzabbix -p zabbix

# Disable log_bin_trust_function_creators option after importing database schema. 
mysql -u root -pAdmin1234 -e "set global log_bin_trust_function_creators = 0;"
#-----------------------

#-----------------------
# d. Configure the database for Zabbix proxy
# Edit file /etc/zabbix/zabbix_proxy.conf
echo "DBPassword=password" >> /etc/zabbix/zabbix_server.conf 
#-----------------------

#-----------------------
# Cambiar lengua del sys para dejar de tener el error de lengua en el UI.
dpkg-reconfigure locales

# Reiniciar los servicios
systemctl restart zabbix-server zabbix-agent apache2
systemctl enable zabbix-server zabbix-agent apache2
#-----------------------

#-----------------------
# 0.0.0.108/zabbix
# http://0.0.0.108/zabbix/setup.php
#-----------------------









