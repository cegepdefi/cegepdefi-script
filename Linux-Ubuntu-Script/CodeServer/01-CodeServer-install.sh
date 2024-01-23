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
    fi
}

function f_tuto_link_vs() {
    # INPUT
    echo -e "${Orange}--> [Link tutorial install/setup] <--${NC}"
    cat <<EOF
-----------------------------------------------------
Link install : https://www.digitalocean.com/community/tutorials/how-to-set-up-the-code-server-cloud-ide-platform-on-ubuntu-18-04

* wget https://github.com/coder/code-server/releases/download/v4.17.1/code-server_4.17.1_amd64.deb
* sudo dpkg -i code-server_4.17.1_amd64.deb

-----------------------------------------------------
* Importante poner la ip y el password en el archivo:
* sudo nano /lib/systemd/system/code-server.service

-----------------------------------------------------
* Quitar Code-Server para poner NewVersion</br>
sudo systemctl stop code-server
sudo rm -r /usr/lib/code-server && sudo rm -r usr/bin/code-server && sudo rm -r /var/lib/code-server
sudo systemctl status code-server
sudo systemctl start code-server
sudo systemctl enable code-server
sudo systemctl disable code-server
-----------------------------------------------------
EOF
}

function f_connectInfo_vs() {
    # INPUT
    echo -e "${Orange}--> [How to connect] <--${NC}"
    echo -e "${Gray}1) Edit Config file and change 127.0.0.1 to you IP. Example: 192.168.0.x ${NC}"
    echo -e "${Gray}2) Set a password in the config file ${NC}"
    echo -e "${Gray}3) Save the config file and restart ${NC}"
    echo -e "${Gray}4) Use status command to confirm code-server is running.. ${NC}"
    echo -e "${Blue}5) http://youIP:8080/?folder=/home/${NC}"
}

function f_install_vs() {
    # INPUT
    echo -e "${Orange}--> [Install | Code-Server] <--${NC}"
    echo -e "${Gray}[INPUT]${NC}${RED} Install Code-Server? (Y/N): ${NC}"
    read -p "" respuesta
    # Convertir la respuesta a minúsculas
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" = "y" ]; then
        echo -e "${Gray}[COMMAND] wget https://github.com/coder/code-server/releases/download/v4.17.1/code-server_4.17.1_amd64.deb ${NC}"
        wget https://github.com/coder/code-server/releases/download/v4.17.1/code-server_4.17.1_amd64.deb

        echo -e "${Gray}[COMMAND] sudo dpkg -i code-server_4.17.1_amd64.deb ${NC}"
        sudo dpkg -i code-server_4.17.1_amd64.deb

        echo -e "${Gray}[COMMAND] rm code-server_4.17.1_amd64.deb ${NC}"
        rm code-server_4.17.1_amd64.deb

        echo -e "${Gray}[*copying*] Copy conf to /lib/systemd/system/code-server.service ${NC}"
        cat <<EOF | sudo tee /lib/systemd/system/code-server.service >/dev/null
[Unit]
Description=code-server
After=nginx.service

[Service]
Type=simple
Environment=PASSWORD=your_password
ExecStart=/usr/bin/code-server --bind-addr 127.0.0.1:8080 --user-data-dir /var/lib/code-server --auth password
Restart=always

[Install]
WantedBy=multi-user.target
EOF

        echo -e "${Gray}[COMMAND] sudo systemctl enable code-server ${NC}"
        sudo systemctl enable code-server

        echo -e "${Gray}[COMMAND] sudo systemctl start code-server ${NC}"
        sudo systemctl start code-server

        echo -e "${Gray}[INPUT]${NC}${RED} Reboot? (Y/N): ${NC}"
        read -p "" respuesta
        # Convertir la respuesta a minúsculas
        respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
        if [ "$respuesta" = "y" ]; then
            echo -e "${Gray}[COMMAND] sudo reboot ${NC}"
            sudo reboot
        fi
    fi
}

function f_defaultBackupFile_vs() {
    # INPUT
    echo -e "${Orange}--> [Show bakup config | Code-Server] <--${NC}"
    cat <<EOF
[Unit]
Description=code-server
After=nginx.service

[Service]
Type=simple
Environment=PASSWORD=your_password
ExecStart=/usr/bin/code-server --bind-addr 127.0.0.1:8080 --user-data-dir /var/lib/code-server --auth password
Restart=always

[Install]
WantedBy=multi-user.target
EOF
}

function f_edit_vs() {
    # INPUT
    echo -e "${Orange}--> [Edit config | Code-Server] <--${NC}"
    echo -e "${Gray}[INPUT]${NC}${RED} Edit config file? (Y/N): ${NC}"
    read -p "" respuesta
    # Convertir la respuesta a minúsculas
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" = "y" ]; then
        echo -e "${Gray}[COMMAND] sudo nano /lib/systemd/system/code-server.service ${NC}"
        sudo nano /lib/systemd/system/code-server.service

        echo -e "${Gray}[INPUT]${NC}${RED} Reboot? (Y/N): ${NC}"
        read -p "" respuesta
        # Convertir la respuesta a minúsculas
        respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
        if [ "$respuesta" = "y" ]; then
            echo -e "${Gray}[COMMAND] sudo reboot ${NC}"
            sudo reboot
        fi
    fi
}

function f_status_vs() {
    # INPUT
    echo -e "${Orange}--> [status | Code-Server] <--${NC}"
    echo -e "${Gray}[COMMAND] sudo systemctl status code-server ${NC}"
    sudo systemctl status code-server
}

function f_start_vs() {
    # INPUT
    echo -e "${Orange}--> [start | Code-Server] <--${NC}"
    echo -e "${Gray}[COMMAND] sudo systemctl start code-server ${NC}"
    sudo systemctl start code-server
}

function f_restart_vs() {
    # INPUT
    echo -e "${Orange}--> [restart | Code-Server] <--${NC}"
    echo -e "${Gray}[COMMAND] sudo systemctl restart code-server ${NC}"
    sudo systemctl restart code-server
    f_reloadDaemon_vs
}

function f_stop_vs() {
    # INPUT
    echo -e "${Orange}--> [stop | Code-Server] <--${NC}"
    echo -e "${Gray}[COMMAND] sudo systemctl stop code-server ${NC}"
    sudo systemctl stop code-server
    f_reloadDaemon_vs
}

function f_enable_vs() {
    # INPUT
    echo -e "${Orange}--> [enable | Code-Server] <--${NC}"
    echo -e "${Gray}[COMMAND] sudo systemctl enable code-server ${NC}"
    sudo systemctl enable code-server
}

function f_disable_vs() {
    # INPUT
    echo -e "${Orange}--> [disable | Code-Server] <--${NC}"
    echo -e "${Gray}[COMMAND] sudo systemctl disable code-server ${NC}"
    sudo systemctl disable code-server
}

function f_firewall_vs() {
    # INPUT
    echo -e "${Orange}--> [disable | Code-Server] <--${NC}"

    echo -e "${Gray}[COMMAND] sudo ufw allow https ${NC}"
    sudo ufw allow https

    echo -e "${Gray}[COMMAND] sudo ufw reload ${NC}"
    sudo ufw reload
}

function f_reloadDaemon_vs(){
    # INPUT
    echo -e "${Orange}--> [systemctl daemon-reload | Code-Server] <--${NC}"

    echo -e "${Gray}[COMMAND] sudo systemctl daemon-reload ${NC}"
    sudo systemctl daemon-reload
}

echo -e "${Blue}############################################################${NC}"
echo -e "${Blue}#                          Menu                            #${NC}"
echo -e "${Blue}############################################################${NC}"

Clear="Clear"
Exit="Exit + Clear"
tuto_link_vs="Link tutorial install/setup"
connectInfo_vs="How to connect"
install_vs="Install | Code-Server"
defaultBackupFile_vs="Show bakup config | Code-Server"
edit_vs="Edit config | Code-Server"
status_vs="Status | Code-Server"
start_vs="Start | Code-Server"
restart_vs="Restart | Code-Server"
reloadDaemon_vs="systemctl daemon-reload | Code-Server"
stop_vs="Stop | Code-Server"
enable_vs="Enable | Code-Server"
disable_vs="Disable | Code-Server"
firewall_vs="Firewall | Code-Server"

PS3="#======= Entrer numero option #======= :" # this displays the common prompt
options=("${Clear}" "${Exit}"
    "${tuto_link_vs}" "${connectInfo_vs}" "${install_vs}"
    "${defaultBackupFile_vs}" "${edit_vs}"
    "${status_vs}" "${start_vs}"
    "${restart_vs}" "${reloadDaemon_vs}" "${stop_vs}"
    "${enable_vs}" "${disable_vs}"
    "${firewall_vs}")

COLUMNS=12
select opt in "${options[@]}"; do
    case $opt in
    "${Clear}")
        f_clear
        ;;
    "${Exit}")
        f_Exit
        ;;
    "${tuto_link_vs}")
        f_tuto_link_vs
        ;;
    "${connectInfo_vs}")
        f_connectInfo_vs
        ;;
    "${install_vs}")
        f_install_vs
        ;;
    "${defaultBackupFile_vs}")
        f_defaultBackupFile_vs
        ;;
    "${edit_vs}")
        f_edit_vs
        ;;
    "${status_vs}")
        f_status_vs
        ;;
    "${start_vs}")
        f_start_vs
        ;;
    "${restart_vs}")
        f_restart_vs
        ;;
    "${reloadDaemon_vs}")
        f_reloadDaemon_vs
        ;;
    "${stop_vs}")
        f_stop_vs
        ;;
    "${enable_vs}")
        f_enable_vs
        ;;
    "${disable_vs}")
        f_disable_vs
        ;;
    "${firewall_vs}")
        f_firewall_vs
        ;;
    *) echo "invalid option $REPLY" ;;
    esac
    COLUMNS=12
done
