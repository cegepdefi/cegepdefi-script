#!/bin/bash

#=========== [ Couleur  ON]=======
RED='\033[0;31m'    #Color Rouge
Orange='\033[0;33m' #Color Orange
Green='\033[1;32m'  #Color Verde
Blue='\033[1;34m'   #Color Blue
Purple='\035[1;34m' #Color Purple
Gray='\033[1;36m'   #Color Gray
NC='\033[0m'        #No Color
#=========== [ Couleur  OFF]=======

function f_MainMenu() {
    echo -e "${Orange}--> [Main Menu] <--${NC}"
    echo -e "${Gray}[COMMAND] sudo -u root bash ./01-menu.sh ${NC}"
    exec sudo -u root bash ./01-menu.sh
    echo -e "${Green}--> END ${NC}"
}

function f_clear() {
    echo -e "${Orange}--> [Clear] <--${NC}"
    clear
    PS3="" # this hides the prompt
    COLUMNS=12
    echo asdf | select foo in "${options[@]}"; do break; done # dummy select
    PS3="#======= Entrer numero option #======= : "           # this displays the common prompt
}

function f_Exit() {
    # INPUT
    echo -e "${Orange}--> [Quiter] <--${NC}"
    echo -e "${Gray}[INPUT]${NC}${RED} Clear? (Y/N): ${NC}"
    read -p "" respuesta
    # Convertir la respuesta a minúsculas
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" = "y" ]; then
        clear
        exit
        break
    else
        break
    fi
}

function f_leer_archivo() {
    local nombreArchivo=$1
    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} Show [${nombreArchivo}] file content? (Y/N): ${NC}"
    read -p "" respuestaguardaroutput22
    # Convertir la respuesta a minúsculas
    respuestaguardaroutput22=$(echo "$respuestaguardaroutput22" | tr '[:upper:]' '[:lower:]')
    if [ "$respuestaguardaroutput22" = "y" ]; then
        # Check if the file exists and read its contents
        if [ -e "$nombreArchivo" ]; then
            echo -e "${Gray}[COMMAND] cat ./$nombreArchivo ${NC}"
            cat ./"$nombreArchivo"
        else
            echo "Error: Output file [./$nombreArchivo] not found."
        fi
    fi
}

function f_instalar_wpscan() {
    echo -e "${Orange}--> [Install wpscan] <--${NC}"
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
    echo -e "${Orange}--> [Uninstall wpscan] <--${NC}"
    # Desinstalar wpscan
    sudo gem uninstall wpscan
    # Desinstalar dependencias (puedes ajustar esta lista según tus necesidades)
    sudo apt remove -y libcurl4-openssl-dev libxml2 libxml2-dev libxslt1-dev ruby-dev build-essential libgmp-dev zlib1g-dev
    # Limpiar paquetes no necesarios
    sudo apt autoremove -y
}

function f_wpscan() {
    # INPUT
    echo -e "${Orange}--> [wpscann url] <--${NC}"
    echo -e "${Gray}[INPUT]${NC}${RED} Enter the Wordpress Server IP: ${NC}"
    read -p "" prompt

    # INPUT
    local apiToken=""
    echo -e "${Orange}[TOKEN]${NC}${Blue} https://wpscan.com/profile ${Orange}to get api Token. ${NC}"
    echo -e "${Gray}[INPUT]${NC}${RED} Use a wpscan api token? (Y/N): ${NC}"
    read -p "" apitokenresponse
    # Convertir la respuesta a minúsculas
    apitokenresponse=$(echo "$apitokenresponse" | tr '[:upper:]' '[:lower:]')
    if [ "$apitokenresponse" = "y" ]; then
        echo -e "${Gray}[INPUT]${NC}${RED} Enter the wscan API TOKEN: ${NC}"
        read -p "" apiToken
    fi

    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} Save the output to a file? (Y/N): ${NC}"
    read -p "" respuestaguardaroutput1
    # Convertir la respuesta a minúsculas
    respuestaguardaroutput1=$(echo "$respuestaguardaroutput1" | tr '[:upper:]' '[:lower:]')
    if [ "$respuestaguardaroutput1" = "y" ]; then
        # INPUT
        echo -e "${Gray}[INPUT]${NC}${RED} change file name? default name is [./wpscan.txt] (Y/N): ${NC}"
        read -p "" respuestaguardaroutput2
        # Convertir la respuesta a minúsculas
        respuestaguardaroutput2=$(echo "$respuestaguardaroutput2" | tr '[:upper:]' '[:lower:]')
        if [ "$respuestaguardaroutput2" = "y" ]; then
            if [ "$apitokenresponse" = "y" ]; then
                # INPUT
                echo -e "${Gray}[INPUT]${NC}${RED} Enter file name with extension [example Response.txt]: ${NC}"
                read -p "" respuestaguardaroutput3
                echo -e "${Gray}[COMMAND] wpscan --url $prompt -e u,vp --api-token $apiToken > ./"$respuestaguardaroutput3" ${NC}"
                wpscan --url "$prompt" -e u,vp --api-token $apiToken >./"$respuestaguardaroutput3"
                f_leer_archivo "$respuestaguardaroutput3"
            else
                # INPUT
                echo -e "${Gray}[INPUT]${NC}${RED} Enter file name with extension [example Response.txt]: ${NC}"
                read -p "" respuestaguardaroutput3
                echo -e "${Gray}[COMMAND] wpscan --url $prompt -e u,vp > ./"$respuestaguardaroutput3" ${NC}"
                wpscan --url "$prompt" -e u,vp >./"$respuestaguardaroutput3"
                f_leer_archivo "$respuestaguardaroutput3"
            fi
        else
            if [ "$apitokenresponse" = "y" ]; then
                echo -e "${Gray}[COMMAND] wpscan --url $prompt -e u,vp --api-token $apiToken > ./wpscan.txt ${NC}"
                wpscan --url $prompt -e u,vp --api-token $apiToken >./wpscan.txt
                f_leer_archivo "wpscan.txt"
            else
                echo -e "${Gray}[COMMAND] wpscan --url $prompt -e u,vp > ./wpscan.txt ${NC}"
                wpscan --url $prompt -e u,vp >./wpscan.txt
                f_leer_archivo "wpscan.txt"
            fi
        fi
    else
        if [ "$apitokenresponse" = "y" ]; then
            echo -e "${Gray}[COMMAND] wpscan --url $prompt -e u,vp --api-token $apiToken${NC}"
            exec wpscan --url $prompt -e u,vp --api-token $apiToken
        else
            echo -e "${Gray}[COMMAND] wpscan --url $prompt -e u,vp ${NC}"
            exec wpscan --url $prompt -e u,vp
        fi
    fi
}

function check_fileExist() {
    local fileName=$1
    # INPUT
    read -p "Enter the IP address of the WordPress server: " server_ip
    # Use curl to check if xmlrpc.php exists
    response_code=$(curl -s -o /dev/null -w "%{http_code}" http://${server_ip}/${fileName})
    # output=$(curl -s -X POST "http://${server_ip}/xmlrpc.php")
    # if [ ${#output} -gt 10 ]; then
    if [ "$response_code" == "200" ]; then
        echo -e "${Green}xmlrpc.php exists on the server. ${NC}"
    else
        echo -e "${RED}xmlrpc.php does not exist on the server.${NC}"
    fi
}

function check_multipleFileExist() {
    read -p "Enter the IP address of the WordPress server: " server_ip

    files=("index.html" "license.txt" "wp-activate.php" "wp-blog-header.php" "wp-config.php"
        "wp-cron.php" "wp-links-opml.php" "wp-login.php" "wp-settings.php" "wp-trackback.php"
        "index.php" "readme.html" "wp-admin" "wp-comments-post.php" "wp-content"
        "wp-includes" "wp-load.php" "wp-mail.php" "wp-signup.php" "xmlrpc.php")

    existing_files=()
    non_existing_files=()

    for file in "${files[@]}"; do
        response_code=$(curl -s -o /dev/null -w "%{http_code}" http://${server_ip}/${file})
        if [ "$response_code" == "200" ]; then
            existing_files+=("$file")
        else
            non_existing_files+=("$file")
        fi
    done

    echo -e "${Green}\nFiles that exist on the server:${NC}"
    printf '%s\n' "${existing_files[@]}"

    echo -e "${Orange}\nFiles that do not exist on the server:${NC}"
    printf '%s\n' "${non_existing_files[@]}"

    check_file_existence_with_headers "$server_ip"
}

function check_file_existence_with_headers() {
    local server_ipx=$1
    # read -p "Enter the IP address of the WordPress server: " server_ip

    echo -e "${NC}"
    echo -e "${Orange}======= [Check with HEADER ON] ======${NC}"
    filesb=("index.html" "license.txt" "wp-activate.php" "wp-blog-header.php" "wp-config.php"
        "wp-cron.php" "wp-links-opml.php" "wp-login.php" "wp-settings.php" "wp-trackback.php"
        "index.php" "readme.html" "wp-admin" "wp-comments-post.php" "wp-content"
        "wp-includes" "wp-load.php" "wp-mail.php" "wp-signup.php" "xmlrpc.php")

    for filex in "${filesb[@]}"; do
        response=$(curl -I -s http://${server_ipx}/${filex})
        response_codex=$(echo "$response" | grep -oP 'HTTP/\d\.\d \K\d+')

        if [ "$response_codex" == "200" ]; then
            # echo -e "${Green}$filex exists on the server.${NC}"
            echo -e "${Green}$filex. HTTP Status Code: $response_codex${NC}"
            echo -e "Headers for $filex:\n$response"
        else
            echo -e "${Orange}Issue with $filex. HTTP Status Code: $response_codex${NC}"
            echo -e "Headers for $filex:\n$response"
            allow_header=$(echo "$response" | grep -i "Allow:")
            if [[ $allow_header == *"POST"* ]]; then
                echo -e "${RED}[SECURITY !!] The file $file allow POST. Is the file protected with Token?${NC}"
            fi
        fi
    done

    echo -e "${Orange}======= [Check with HEADER OFF] =======${NC}"
    echo -e "${NC}"
}

function f_xmlrpc() {
    local archivoEnviar=$1
    # INPUT
    echo -e "${Orange}--> [xmlrpc] <--${NC}"
    echo -e "${Gray}[INPUT]${NC}${RED} Enter the Wordpress Server IP: ${NC}${Green}"
    read -p "" prompt
    echo -e "${NC}"

    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} Save the output to a file? (Y/N): ${NC}"
    read -p "" respuestaguardaroutput1
    # Convertir la respuesta a minúsculas
    respuestaguardaroutput1=$(echo "$respuestaguardaroutput1" | tr '[:upper:]' '[:lower:]')
    if [ "$respuestaguardaroutput1" = "y" ]; then
        # INPUT
        echo -e "${Gray}[INPUT]${NC}${RED} change file name? default name is [./xmlrpc.php] (Y/N): ${NC}"
        read -p "" respuestaguardaroutput2
        # Convertir la respuesta a minúsculas
        respuestaguardaroutput2=$(echo "$respuestaguardaroutput2" | tr '[:upper:]' '[:lower:]')
        if [ "$respuestaguardaroutput2" = "y" ]; then
            # INPUT
            echo -e "${Gray}[INPUT]${NC}${RED} Enter file name with extension [example .php]: ${NC}"
            read -p "" respuestaguardaroutput3
            echo -e "${Gray}[COMMAND] curl -X POST 'http://$prompt/xmlrpc.php' -d@$archivoEnviar > ./"$respuestaguardaroutput3" ${NC}"
            curl -X POST "http://${prompt}/xmlrpc.php" -d@"$archivoEnviar" >./"$respuestaguardaroutput3"
            f_leer_archivo "$respuestaguardaroutput3"
        else
            echo -e "${Gray}[COMMAND] curl -X POST "http://${prompt}/xmlrpc.php" -d@$archivoEnviar > ./xmlrpc.php ${NC}"
            curl -X POST "http://${prompt}/xmlrpc.php" -d@"$archivoEnviar" >./xmlrpc.php
            f_leer_archivo "xmlrpc.php"
        fi
    else
        echo -e "${Gray}[COMMAND] curl -X POST "http://${prompt}/xmlrpc.php" -d@$archivoEnviar ${NC}"
        exec curl -X POST "http://${prompt}/xmlrpc.php" -d@"$archivoEnviar"
    fi
}

echo -e "${Blue}############################################################${NC}"
echo -e "${Blue}#                Kali Linux Wordpress Scan                 #${NC}"
echo -e "${Blue}############################################################${NC}"

Clear="Clear"
Exit="Exit + Clear"
installwpscan="Install WPSCAN"
uninstallwpscan="Uninstall WPSCAN"
OptionWpscan="wpscann url"
OptionCheckReadmeExist="Check file [readme.html] exist"
OptionCheckMultipleFileExist="Check multiple files exist"
OptionXmlrpcn01="POST/Save the [xmlrpcn.php] file + [enviar01.xml]"
OptionXmlrpcn02="POST/Save the [xmlrpcn.php] file + [enviar02.xml]"

PS3="#======= Entrer numero option #======= :" # this displays the common prompt
options=("${Clear}" "${Exit}"
    "${installwpscan}" "${uninstallwpscan}" "${OptionWpscan}"
    "${OptionCheckReadmeExist}" "${OptionCheckMultipleFileExist}"
    "${OptionXmlrpcn01}" "${OptionXmlrpcn02}")

COLUMNS=12
select opt in "${options[@]}"; do
    case $opt in
    "${Clear}")
        f_clear
        ;;
    "${Exit}")
        f_Exit
        ;;
    "${installwpscan}")
        f_instalar_wpscan
        ;;
    "${uninstallwpscan}")
        f_desinstalar_wpscan
        ;;
    "${OptionWpscan}")
        f_wpscan
        ;;
    "${OptionCheckReadmeExist}")
        check_fileExist "readme.html"
        ;;
    "${OptionCheckMultipleFileExist}")
        check_multipleFileExist
        ;;
    "${OptionXmlrpcn01}")
        f_xmlrpc "enviar01.xml"
        ;;
    "${OptionXmlrpcn02}")
        f_xmlrpc "enviar02.xml"
        ;;
    *) echo "invalid option $REPLY" ;;
    esac
    COLUMNS=12
done
