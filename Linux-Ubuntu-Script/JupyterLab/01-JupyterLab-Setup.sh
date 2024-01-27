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

function f_updates() {
    # Update and upgrade the system
    echo -e "${Gray}[COMMAND] sudo apt-get update -y ${NC}"
    sudo apt-get update -y
    echo -e "${Gray}[COMMAND] sudo apt-get upgrade -y ${NC}"
    sudo apt-get upgrade -y
    echo -e "${Green}----> [OK] (f_updates) COMPLETED !! <----${NC}"
}

function f_installs_pip_env() {
    # Install pip
    echo -e "${Gray}[COMMAND] sudo apt-get install -y python3-pip ${NC}"
    sudo apt-get install -y python3-pip
    # Install virtualenv
    echo -e "${Gray}[COMMAND] sudo pip3 install -U virtualenv ${NC}"
    sudo pip3 install -U virtualenv
    f_setup_env
    echo -e "${Green}----> [OK] (f_installs_pip_env) COMPLETED !! <----${NC}"
}

function f_setup_env() {
    # Create and activate a new Python virtual environment
    echo -e "${Gray}[COMMAND] virtualenv --system-site-packages -p python3 jupyterlab_env ${NC}"
    virtualenv --system-site-packages -p python3 jupyterlab_env
    echo -e "${Gray}[COMMAND] source jupyterlab_env/bin/activate ${NC}"
    source jupyterlab_env/bin/activate
    f_nose
    echo -e "${Green}----> [OK] (f_setup_env) COMPLETED !! <----${NC}"
}

function f_nose() {
    # Update pip package manager and deactivate the virtual environment
    echo -e "${Gray}[COMMAND] pip install --upgrade pip ${NC}"
    pip install --upgrade pip
    echo -e "${Gray}[COMMAND] deactivate ${NC}"
    deactivate
    echo -e "${Green}----> [OK] (f_nose) COMPLETED !! <----${NC}"
}

function f_install_JupyterLab() {
    # Install JupyterLab
    echo -e "${Gray}[COMMAND] sudo pip3 install -U jupyterlab ${NC}"
    sudo pip3 install -U jupyterlab
    echo -e "${Green}----> [OK] (f_install_JupyterLab) COMPLETED !! <----${NC}"
}

# Variable publica para poner passw en MySQL en la instalacion...
jupyterLab_password=""

function f_pedir_contrasena() {
    # Solicitar al usuario Contra para MySQL
    echo -e "${RED}"
    echo "Create JupyterLab password for (c.ServerApp.password='yourpasswd') in the config file (~/.jupyter/jupyter_lab_config.py)"
    read -p ": " jupyterLab_password
    echo -e "${NC}"
    echo -e "${Green}----> [OK] (f_pedir_contrasena) COMPLETED !! <----${NC}"
}

function f_crear_contrasena_jupyterLab() {
    # Bucle para asegurarse de que la contraseña tenga al menos 4 caracteres
    while true; do
        f_pedir_contrasena

        # Verificar la longitud de la contraseña
        if [ ${#jupyterLab_password} -ge 4 ]; then
            echo -e "${Green}Password accepted.${NC}"
            break
        else
            echo "The password must be at least 4 characters. Try again."
        fi
    done

    # Aquí puedes continuar con el resto de tu script utilizando la variable $jupyterLab_password
    echo -e "${Blue}The password entered is: ${NC}${Orange}" $jupyterLab_password "${NC}"
    echo
    echo -e "${Green}----> [OK] (f_crear_contrasena_jupyterLab) COMPLETED !! <----${NC}"
}

function f_edit_config_JupyterLab() {
    f_crear_contrasena_jupyterLab

    # Generate a password hash
    PASSWORD_HASH=$(python3 -c "from jupyter_server.auth import passwd; print(passwd('$jupyterLab_password'))")

    # Generate a JupyterLab configuration file
    echo -e "${Gray}#Generate a JupyterLab configuration file${NC}"
    echo -e "${Gray}[COMMAND] jupyter lab --generate-config ${NC}"
    jupyter lab --generate-config

    # Edit the configuration file
    echo -e "${Gray}#Edit the configuration file{NC}"
    echo -e "${Gray}[COMMAND] c.ServerApp.password = PASSWORD_HASH >>~/.jupyter/jupyter_lab_config.py ${NC}"
    echo "c.ServerApp.password = '$PASSWORD_HASH'" >>~/.jupyter/jupyter_lab_config.py
    echo -e "${Gray}[COMMAND] c.ServerApp.allow_remote_access = True >>~/.jupyter/jupyter_lab_config.py ${NC}"
    echo "c.ServerApp.allow_remote_access = True" >>~/.jupyter/jupyter_lab_config.py
    echo -e "${Gray}[COMMAND] c.NotebookApp.allow_origin = '*' >>~/.jupyter/jupyter_lab_config.py ${NC}"
    echo "c.NotebookApp.allow_origin = '*'" >>~/.jupyter/jupyter_lab_config.py
    echo -e "${Gray}[COMMAND] c.NotebookApp.ip = '0.0.0.0' >>~/.jupyter/jupyter_lab_config.py ${NC}"
    echo "c.NotebookApp.ip = '0.0.0.0'" >>~/.jupyter/jupyter_lab_config.py
}

function f_config_JupyterLab() {
    f_edit_config_JupyterLab

    # Create a new service for JupyterLab
    echo -e "${Gray}#Create a new service for JupyterLab${NC}"
    echo "[Unit]
Description=JupyterLab
After=network.target

[Service]
Type=simple
ExecStart=/usr/local/bin/jupyter lab --config=~/.jupyter/jupyter_lab_config.py
User=$USER
Group=$USER
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target" | sudo tee /lib/systemd/system/jupyterlab.service
    echo -e "${Green}----> [OK] (f_config_JupyterLab) COMPLETED !! <----${NC}"
}

function f_JupyterLab_service() {
    # Enable and start the service
    echo -e "${Gray}[COMMAND] sudo systemctl enable jupyterlab ${NC}"
    sudo systemctl enable jupyterlab
    echo -e "${Gray}[COMMAND] sudo systemctl start jupyterlab ${NC}"
    sudo systemctl start jupyterlab
    echo -e "${Gray}[COMMAND] sudo systemctl status jupyterlab ${NC}"
    sudo systemctl status jupyterlab
    echo -e "${Green}----> [OK] (f_JupyterLab_service) COMPLETED !! <----${NC}"
}

function f_status() {
    echo -e "${Gray}[COMMAND] sudo systemctl status jupyterlab ${NC}"
    sudo systemctl status jupyterlab
}

function f_restart() {
    echo -e "${Gray}[COMMAND] sudo systemctl restart jupyterlab ${NC}"
    sudo systemctl restart jupyterlab
}

echo -e "${Blue}############################################################${NC}"
echo -e "${Blue}#                          Menu                            #${NC}"
echo -e "${Blue}############################################################${NC}"

Clear="Clear"
Exit="Exit + Clear"
updates="updates"
installs_pip_env="installs pip + env"
install_JupyterLab="install JupyterLab"
config_JupyterLab="config JupyterLab"
edit_config_JupyterLab="Edit config JupyterLab"
JupyterLab_status="JupyterLab status service"
JupyterLab_start="JupyterLab start service"
JupyterLab_restart="JupyterLab restart service"
JupyterLab_ip="Show ip"
JupyterLab_connect_info="How to connect to the JupyterLab website"

PS3="#======= Entrer numero option #======= :" # this displays the common prompt
options=("${Clear}" "${Exit}"
    "${updates}" "${installs_pip_env}"
    "${install_JupyterLab}" "${config_JupyterLab}" "${edit_config_JupyterLab}"
    "${JupyterLab_status}" "${JupyterLab_start}" "${JupyterLab_restart}"
    "${JupyterLab_ip}" "${JupyterLab_connect_info}")

COLUMNS=12
select opt in "${options[@]}"; do
    case $opt in
    "${Clear}")
        f_clear
        ;;
    "${Exit}")
        f_Exit
        ;;
    "${updates}")
        f_updates
        ;;
    "${installs_pip_env}")
        f_installs_pip_env
        ;;
    "${install_JupyterLab}")
        f_install_JupyterLab
        ;;
    "${config_JupyterLab}")
        f_config_JupyterLab
        ;;
    "${edit_config_JupyterLab}")
        f_edit_config_JupyterLab
        ;;
    "${JupyterLab_status}")
        f_status
        ;;
    "${JupyterLab_start}")
        f_JupyterLab_service
        ;;
    "${JupyterLab_restart}")
        f_restart
        ;;
    "${JupyterLab_ip}")
        ip add
        ;;
    "${JupyterLab_connect_info}")
        echo "Enter http://youIP:8888/lab"
        ;;
    *) echo "invalid option $REPLY" ;;
    esac
    COLUMNS=12
done
