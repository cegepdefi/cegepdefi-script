#!/bin/bash

# Obtener el nombre del script
nombre_script=$(basename "$0")

# Variable publica para poner passw en MySQL en la instalacion...
mysql_password=""

f_pedir_contrasena() {
    # Solicitar al usuario Contra para MySQL
    echo -e "${RED}"
    read -p "Create MySQL password for user (wordpress and phpmyadmin): " mysql_password
    echo -e "${NC}"
}

f_crear_contrasena_mysql() {
    # Bucle para asegurarse de que la contraseña tenga al menos 4 caracteres
    while true; do
        f_pedir_contrasena

        # Verificar la longitud de la contraseña
        if [ ${#mysql_password} -ge 4 ]; then
            echo -e "${Green}Password accepted.${NC}"
            break
        else
            echo "The password must be at least 4 characters. Try again."
        fi
    done

    # Aquí puedes continuar con el resto de tu script utilizando la variable $mysql_password
    echo -e "${Blue}The password entered is: ${NC}${Orange}" $mysql_password "${NC}"
    echo
}

f_instalar_wordpress() {
    # Executar: yes | sudo sh ./Wordpress-install.sh
    f_crear_contrasena_mysql

    # Update package list
    sudo apt-get update

    # Install Apache
    sudo apt-get install apache2 curl -y

    # Install MySQL
    sudo apt-get install mysql-server -y

    # Install PHP
    sudo apt-get install php libapache2-mod-php php-mysql -y

    # Download WordPress
    cd /tmp
    curl -O https://wordpress.org/latest.tar.gz

    # Extract WordPress
    tar xzvf latest.tar.gz

    # Copy WordPress files to Apache directory
    sudo rsync -avP /tmp/wordpress/ /var/www/html/

    # Set permissions on Apache directory
    sudo chown -R www-data:www-data /var/www/html/
    sudo chmod -R 755 /var/www/html/

    # Create MySQL database for WordPress
    sudo mysql -u root -p <<EOF
    CREATE DATABASE wordpress;
    CREATE USER 'wordpress'@'localhost' IDENTIFIED WITH mysql_native_password BY '$mysql_password';
    GRANT ALL PRIVILEGES ON *.* TO 'wordpress'@'localhost';
    GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost';
    FLUSH PRIVILEGES;
EOF

    # Configure WordPress
    cd /var/www/html/
    curl -O https://raw.githubusercontent.com/WordPress/WordPress/master/wp-config-sample.php
    rm /var/www/html/index.html
    ls wp-config-sample.php
    sudo mv wp-config-sample.php wp-config.php
    sudo sed -i "s/database_name_here/wordpress/g" wp-config.php
    sudo sed -i "s/username_here/wordpress/g" wp-config.php
    sudo sed -i "s/password_here/$mysql_password/g" wp-config.php

    # Restart Apache service
    sudo systemctl restart apache2.service

    # FIN
    echo -e "\e[0;33m http://ip/readme.html \e[0m"

    # ========================================================

    sudo apt update && sudo apt upgrade -y
    sudo apt-get install -y phpmyadmin php-mbstring

    sudo mysql -u root -p <<EOF
    # ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$mysql_password';
    ALTER USER 'wordpress'@'localhost' IDENTIFIED WITH mysql_native_password BY '$mysql_password';
    ALTER USER 'phpmyadmin'@'localhost' IDENTIFIED WITH mysql_native_password BY '$mysql_password';
    GRANT ALL PRIVILEGES ON *.* TO 'phpmyadmin'@'localhost';
    GRANT ALL PRIVILEGES ON wordpress.* TO 'phpmyadmin'@'localhost';
    FLUSH PRIVILEGES;
EOF
}

f_ip_wordpress() {
    echo
    # Obtener la lista de direcciones IP
    ip_list=$(hostname -I)

    # Convertir la lista en un array
    ip_array=($ip_list)

    # Mostrar las Available IP addresses al usuario
    echo -e "${Green}Available IP addresses:${NC}"
    for ((i = 0; i < ${#ip_array[@]}; i++)); do
        echo -e "[$i] ${Blue}${ip_array[$i]}${NC}"
    done

    # Pedir al usuario que seleccione una IP
    echo -e "${RED}"
    read -p "Select the IP number you want to use as the new URL. (Example: 0) : " ip_index
    echo -e "${NC}"

    # Verificar si el indice seleccionado es valido
    if [[ $ip_index -ge 0 && $ip_index -lt ${#ip_array[@]} ]]; then
        nueva_url="http://${ip_array[$ip_index]}"
        echo -e "${Blue}New URL: $nueva_url ${NC}"
    else
        echo -e "${Orange}Invalid selection. Exiting the script.${NC}"
        exit 1
    fi

    f_mostrar_BaseDeDatos_Selecionar_BaseDeDatos $nueva_url
}

mostrar_usuarios_mysql() {
    local usuario
    local password
    local respuesta

    while true; do
        echo -e "${Green}If you have already installed Wordpress you should be able to use the (wordpress and phpmyadmin) users with the password you entered at the beginning of the installation.${NC}"
        echo -e "${Orange}--- [MySQL Connection] ---${NC}${RED}"
        read -p "Enter MySQL username: " usuario
        read -p "Enter MySQL password: " password
        echo -e "${NC}"

        # Probar la conexión con el usuario y contraseña proporcionados
        if mysql -u "$usuario" -p"$password" -e "SELECT 1;" 2>/dev/null; then
            echo -e "${Green}Successful connection with the user $usuario.${NC}"
            break
        else
            echo "Connection error with the provided username and password."

            read -p "Do you want to try again? (Y/N): " respuesta

            if [ "$respuesta" != "y" ]; then
                echo "Leaving the function."
                return
            fi
        fi
    done

    # Consulta SQL para obtener usuarios y sus derechos
    consulta="SELECT user, host FROM mysql.user;"

    # Ejecutar la consulta utilizando el comando mysql y formatear la salida
    resultados=$(mysql -u "$usuario" -p"$password" -e "$consulta" 2>/dev/null | column -t)

    # Verificar si la ejecución de la consulta fue exitosa
    if [ $? -eq 0 ]; then
        echo "=== Users MySQL ==="
        echo "$resultados"
        echo "======================"
    else
        echo "Error executing the query. Verify MySQL credentials."
    fi
}

cambiar_contrasena_mysql() {
    #==========[Mostrar usuarios en MySQL]=============
    echo -e "${RED}"
    read -p "Do you want to see all users in MySQL? (Y/N): " respuesta1
    echo -e "${NC}"
    # Convertir la respuesta1 a minúsculas
    respuesta1=$(echo "$respuesta1" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta1" = "y" ]; then
        # Mostrar usuarios
        mostrar_usuarios_mysql
    else
        echo
    fi
    #===================================================

    #==========[Conectarse a MySQL]====================
    local usuario
    local password
    local respuesta2
    while true; do
        echo -e "${Green}If you have already installed Wordpress you should be able to use the (wordpress and phpmyadmin) users with the password you entered at the beginning of the installation.${NC}"
        echo -e "${Orange}--- [MySQL Connection] ---${NC}${RED}"
        read -p "Enter MySQL username: " usuario
        read -p "Enter MySQL password: " password
        echo -e "${NC}"

        # Probar la conexión con el usuario y contraseña proporcionados
        if mysql -u "$usuario" -p"$password" -e "SELECT 1;" 2>/dev/null; then
            echo -e "${Green}Successful connection with the user $usuario.${NC}"
            break
        else
            echo "Connection error with the provided username and password."

            read -p "Do you want to try again? (Y/N): " respuesta

            if [ "$respuesta" != "y" ]; then
                echo "Leaving the function."
                return
            fi
        fi
    done
    #===================================================

    echo

    #==========[Selecionar el usuario de MySQL para cambiar Passw]====================
    echo -e "${Orange}--- [MySQL user new password] ---${NC}${RED}"
    read -p "Enter the MySQL username to change the password: " select_usuario
    read -p "Enter the new password: " nueva_password
    echo -e "${NC}"
    #================================================================================

    # Consulta SQL para obtener usuarios y sus derechos
    consulta="ALTER USER '$select_usuario'@'localhost' IDENTIFIED BY '$nueva_password';"

    # Ejecutar la consulta utilizando el comando mysql
    resultados=$(mysql -u "$usuario" -p"$password" -e "$consulta" 2>/dev/null | column -t)

    if [ $? -eq 0 ]; then
        echo -e "${Green}Password successfully changed for user $select_usuario.${NC}"
    else
        echo -e "${RED}Error changing password.${NC}"
    fi
}

f_mostrar_BaseDeDatos_Selecionar_BaseDeDatos() {
    #==========[Conectarse a MySQL]====================
    local mysql_user
    local mysql_password
    local respuesta2
    while true; do
        echo -e "${Green}If you have already installed Wordpress you should be able to use the (wordpress and phpmyadmin) users with the password you entered at the beginning of the installation.${NC}"
        echo -e "${Orange}--- [MySQL Connection] ---${NC}${RED}"
        read -p "Enter MySQL username: " mysql_user
        read -p "Enter MySQL password: " mysql_password
        echo -e "${NC}"

        # Probar la conexión con el usuario y contraseña proporcionados
        if mysql -u "$mysql_user" -p"$mysql_password" -e "SELECT 1;" 2>/dev/null; then
            echo -e "${Green}Successful connection with the user $mysql_user.${NC}"
            break
        else
            echo "Connection error with the provided username and password."

            read -p "Do you want to try again? (Y/N): " respuesta

            if [ "$respuesta" != "y" ]; then
                echo "Leaving the function."
                return
            fi
        fi
    done
    #===================================================

    # Ejecutar "show databases" y almacenar la salida en una variable
    databases=$(mysql -u "$mysql_user" -p"$mysql_password" -e "show databases")

    # Convertir la lista de bases de datos en un array
    database_array=($databases)

    # Mostrar las bases de datos disponibles al usuario
    echo -e "${Green}Available databases:${NC}"
    for ((i = 0; i < ${#database_array[@]}; i++)); do
        echo -e "[$i]${Blue} ${database_array[$i]}${NC}"
    done

    # Pedir al usuario que seleccione una base de datos
    echo -e "${Orange}"
    read -p "Select the database number you want to use: " db_index
    echo -e "${NC}"

    # Verificar si el índice seleccionado es valido
    if [[ $db_index -ge 0 && $db_index -lt ${#database_array[@]} ]]; then
        selected_database="${database_array[$db_index]}"
        echo -e "${Green}Selected database: $selected_database${NC}"
    else
        echo -e "${Orange}Invalid selection. Exiting the script.${NC}"
        exit 1
    fi

    # Ejecutar la consulta SQL utilizando la base de datos seleccionada
    # mysql -u "$mysql_user" -p"$mysql_password" -D "$selected_database" -e "UPDATE wp_options SET option_value='http://nueva_url' WHERE option_name = 'siteurl';"

    # Mostrar ip de WP
    echo -e "${Blue} -------------[Before changes]------------- ${NC}"
    mysql -u "$mysql_user" -p"$mysql_password" -D "$selected_database" -e "SELECT * FROM wp_options WHERE option_name IN('siteurl','home');"
    echo -e "${Blue} --------------------------------- ${NC}"

    mysql -u "$mysql_user" -p"$mysql_password" <<EOF
    USE $selected_database;
    UPDATE wp_options SET option_value='$1' WHERE option_name = 'siteurl';
    UPDATE wp_options SET option_value='$1' WHERE option_name = 'home';
EOF

    # Mostrar ip de WP
    echo -e "${Blue} -------------[After changes]------------- ${NC}"
    mysql -u "$mysql_user" -p"$mysql_password" -D "$selected_database" -e "SELECT * FROM wp_options WHERE option_name IN('siteurl','home');"
    echo -e "${Blue} ----------------------------------- ${NC}"
}

resetear_contrasena_root() {
    echo -e "${RED}"
    read -p "Do you want to see the instructions to know how to change the root user password for MySQL manually? (Y/N): " respuesta
    echo -e "${NC}"

    # Convertir la respuesta a minúsculas
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')

    if [ "$respuesta" = "y" ]; then
        echo -e "${Orange}Below are the steps to reset the root password in MySQL:${NC}"
        echo -e "${Blue}1. Open a terminal and run the following command as ROOT to connect to MySQL as root:${NC}"
        echo -e "${Green} mysql -u root -p${NC}"
        echo -e "${Blue}2. Enter the current root password when prompted. By default root does not have a password.${NC}"
        echo -e "${Blue}3. Run the following command to change the root password:${NC}"
        echo -e "${Green} ALTER USER 'root'@'localhost' IDENTIFIED BY 'New_Password';${NC}"
        echo -e "${Orange} ->Replace 'new_password' with the new password you want to set.${NC}"
        echo -e "${Blue}4. Run the following command to reload privileges:${NC}"
        echo -e "${Green} FLUSH PRIVILEGES;${NC}"
        echo -e "${Blue}5. Exit the MySQL session by typing:${NC}"
        echo -e "${Green} exit${NC}"
        echo -e "${Orange}Ready! The root password in MySQL has been changed.${NC}"

    else
        echo -e "${Orange}You did not enter the letter "Y" so the instructions will not be displayed.${NC}"
    fi
}

function f_instalar_wpscan() {
    # Actualizar el índice de paquetes
    sudo apt update
    # Instalar dependencias necesarias
    sudo apt install -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
    # Instalar Ruby (si aún no está instalado)
    sudo apt install -y ruby
    # Instalar wpscan
    sudo gem install wpscan
    # Verificar la instalación
    wpscan --version
}

function f_desinstalar_wpscan() {
    # Desinstalar wpscan
    sudo gem uninstall wpscan
    # Desinstalar dependencias (puedes ajustar esta lista según tus necesidades)
    sudo apt remove -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
    # Limpiar paquetes no necesarios
    sudo apt autoremove -y
}

# ======================================================
RED='\033[0;31m'    #Color Rouge
Orange='\033[0;33m' #Color Orange
Green='\033[1;32m'  #Color Verde
Blue='\033[1;34m'   #Color Blue
Purple='\035[1;34m' #Color Purple
Gray='\033[1;36m'   #Color Gray
NC='\033[0m'        #No Color
# ======================================================

# ======================================================
echo -e "${Orange}"
echo -e "############################################################"
echo -e "#                     Main Script                          #"
echo -e "############################################################"
echo -e "${NC}"
echo -e "${RED}sudo chmod +x ./$nombre_script${NC}"
echo -e "${RED}sudo ./$nombre_script${NC}"
echo
# ======================================================

# ======================================================
Limpiar="Clear"
Exit="Exit + Clear"
installwp="Install Worpdress"
showallmysqlusers="Show all MySQL Users"
changemysqluserpassw="Change a MySQL Users password"
resetrootmysql="Reset root password for MySQL"
changeip="Change Wordpress IP"
installwpscan="Install WPSCAN"
uninstallwpscan="Uninstall WPSCAN"
# ======================================================

PS3="#======= [MENU] Entrer numero option #======= :" # this displays the common prompt
options=("${Limpiar}" "${Exit}" "${installwp}" 
"${showallmysqlusers}" "${changemysqluserpassw}" 
"${resetrootmysql}" "${changeip}"
"${installwpscan}" "${uninstallwpscan}")

COLUMNS=12
select opt in "${options[@]}"; do
    case $opt in
    "${Limpiar}")
        echo -e "${Orange}--> [Limpiar] <--${NC}"
        clear
        PS3="" # this hides the prompt
        COLUMNS=12
        echo asdf | select foo in "${options[@]}"; do break; done # dummy select
        PS3="#======= [MENU] Entrer numero option #======= : "    # this displays the common prompt
        ;;
    "${Exit}")
        echo -e "${Orange}--> [Exit] <--${NC}"
        echo -e "${Blue}--> clear ? Y / N ${NC}"
        read -p "" prompt
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]; then
            clear
            break
        else
            break
        fi
        ;;
    "${installwp}")
        echo -e "${Orange}--> [Install Wordpress] <--${NC}"
        f_instalar_wordpress
        ;;
    "${showallmysqlusers}")
        echo -e "${Orange}--> [Show all users in MySQL] <--${NC}"
        mostrar_usuarios_mysql
        echo
        ;;
    "${changemysqluserpassw}")
        echo -e "${Orange}--> [Change MySQL user password] <--${NC}"
        # Cambiar contraseña
        cambiar_contrasena_mysql
        echo
        ;;
    "${resetrootmysql}")
        echo -e "${Orange}--> [Reset root password for MySQL] <--${NC}"
        resetear_contrasena_root
        echo
        ;;
    "${changeip}")
        echo -e "${Orange}--> [Change wordpress IP] <--${NC}"
        f_ip_wordpress
        echo
        echo -e "${RED}If you have the following error: (Table 'wordpress.wp_options' doesn't exist)"
        echo -e "it means WordPress is installed correctly"
        echo -e "but you have not yet entered /wp-admin and complete the basic configuration, such as domain name, username and password...${NC}"
        echo
        ;;
    "${installwpscan}")
        echo -e "${Orange}--> [Install wpscan] <--${NC}"
        f_instalar_wpscan
        echo
        ;;
    "${uninstallwpscan}")
        echo -e "${Orange}--> [Uninstall wpscan] <--${NC}"
        f_desinstalar_wpscan
        echo
        ;;
    *) echo "invalid option $REPLY" ;;
    esac
    COLUMNS=12
done
