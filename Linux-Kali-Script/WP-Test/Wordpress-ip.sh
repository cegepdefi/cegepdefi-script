#!/bin/bash

f_cambiar_ip_wordpress() {
    # Obtener la lista de direcciones IP
    ip_list=$(hostname -I)

    # Convertir la lista en un array
    ip_array=($ip_list)

    # Mostrar las direcciones IP disponibles al usuario
    echo "Direcciones IP disponibles:"
    for ((i=0; i<${#ip_array[@]}; i++)); do
        echo "[$i] ${ip_array[$i]}"
    done

    # Pedir al usuario que seleccione una IP
    read -p "Selecciona el número de la IP que deseas utilizar como nueva URL: " ip_index

    # Verificar si el índice seleccionado es válido
    if [[ $ip_index -ge 0 && $ip_index -lt ${#ip_array[@]} ]]; then
        nueva_url="http://${ip_array[$ip_index]}"
        echo "Nueva URL: $nueva_url"
    else
        echo "Selección no válida. Saliendo del script."
        exit 1
    fi

    f_mostrar_BaseDeDatos_Selecionar_BaseDeDatos $nueva_url
# sudo mysql -u root -p <<EOF
# UPDATE wp_options SET option_value='$nueva_url' WHERE option_name = 'siteurl';
# UPDATE wp_options SET option_value='$nueva_url' WHERE option_name = 'home';
# EOF
}



f_mostrar_BaseDeDatos_Selecionar_BaseDeDatos() {
    # Solicitar al usuario credenciales de MySQL
    read -p "Nombre de usuario de MySQL: " mysql_user
    read -s -p "Contraseña de MySQL: " mysql_password
    echo

    # Ejecutar "show databases" y almacenar la salida en una variable
    databases=$(mysql -u "$mysql_user" -p"$mysql_password" -e "show databases")

    # Convertir la lista de bases de datos en un array
    database_array=($databases)

    # Mostrar las bases de datos disponibles al usuario
    echo "Bases de datos disponibles:"
    for ((i=0; i<${#database_array[@]}; i++)); do
        echo "[$i] ${database_array[$i]}"
    done

    # Pedir al usuario que seleccione una base de datos
    read -p "Selecciona el número de la base de datos que deseas utilizar: " db_index

    # Verificar si el índice seleccionado es válido
    if [[ $db_index -ge 0 && $db_index -lt ${#database_array[@]} ]]; then
        selected_database="${database_array[$db_index]}"
        echo "Base de datos seleccionada: $selected_database"
    else
        echo "Selección no válida. Saliendo del script."
        exit 1
    fi

    # Ejecutar la consulta SQL utilizando la base de datos seleccionada
    # mysql -u "$mysql_user" -p"$mysql_password" -D "$selected_database" -e "UPDATE wp_options SET option_value='http://nueva_url' WHERE option_name = 'siteurl';"

    # Mostrar ip de WP
    echo -e "${Blue} -------------[Antes]------------- ${NC}";
    mysql -u "$mysql_user" -p"$mysql_password" -D "$selected_database" -e "SELECT * FROM wp_options WHERE option_name IN('siteurl','home');"
    echo -e "${Blue} --------------------------------- ${NC}"; 

mysql -u "$mysql_user" -p"$mysql_password" <<EOF
USE $selected_database;
UPDATE wp_options SET option_value='$1' WHERE option_name = 'siteurl';
UPDATE wp_options SET option_value='$1' WHERE option_name = 'home';
EOF

    # Mostrar ip de WP
    echo -e "${Blue} -------------[Despues]------------- ${NC}";
    mysql -u "$mysql_user" -p"$mysql_password" -D "$selected_database" -e "SELECT * FROM wp_options WHERE option_name IN('siteurl','home');"
    echo -e "${Blue} ----------------------------------- ${NC}"; 
}



# ======================================================
RED='\033[0;31m' #Color Rouge
Orange='\033[0;33m' #Color Orange
Green='\033[1;32m' #Color Verde
Blue='\033[1;34m' #Color Blue
Purple='\035[1;34m' #Color Purple
Gray='\033[1;36m' #Color Gray
NC='\033[0m' #No Color
# ======================================================


# ======================================================
echo -e "${Orange}";
echo -e "############################################################";
echo -e "#                     Main Script                          #";
echo -e "############################################################";
echo -e "${NC}";
# ======================================================


# ======================================================
Limpiar="clear";
Exit="Exit + Clear";
ipwp="Set Wordpress IP";
# ======================================================


PS3="#======= [MENU] Entrer numero option #======= :" # this displays the common prompt
options=("${Limpiar}" "${Exit}" "${ipwp}");

COLUMNS=12;
select opt in "${options[@]}"
do
    case $opt in
        "${Limpiar}")
            echo -e "${Blue}--> Limpiar ${NC}";
            clear;
            PS3="" # this hides the prompt
            COLUMNS=12;
            echo asdf | select foo in "${options[@]}"; do break; done # dummy select
            PS3="#======= [MENU] Entrer numero option #======= : " # this displays the common prompt
        ;;
        "${Exit}")
            echo -e "${Blue}--> clear ? Y / N ${NC}";
            read -p "" prompt
            if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
            then
                clear;
                break
            else
                break
            fi
        ;;
        "${ipwp}")
            f_cambiar_ip_wordpress
        ;;
        *) echo "invalid option $REPLY";;
    esac
    COLUMNS=12
done