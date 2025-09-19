#!/bin/bash
#=========== [ Couleur  ON]=======
RED='\033[0;31m' #Color Rouge
Orange='\033[0;33m' #Color Orange
Green='\033[1;32m' #Color Verde
Blue='\033[1;34m' #Color Blue
Purple='\035[1;34m' #Color Purple
Gray='\033[1;36m' #Color Gray
NC='\033[0m' #No Color
#=========== [ Couleur  OFF]=======


function f_MainMenu() {
    echo -e "${Blue}--> 00-menu.sh ${NC}"
    exec sudo -u root bash ./00-menu.sh
    echo -e "${Green}--> END ${NC}"
}


function f_clean() {
    echo -e "${Blue}--> clean ${NC}";
    clear;
    PS3="" # this hides the prompt
    COLUMNS=12;
    echo asdf | select foo in "${options[@]}"; do break; done # dummy select
    PS3="#======= Entrer option #======= : " # this displays the common prompt
}


function f_Exit() {
    echo -e "${Blue}--> clean ? Y / N ${NC}";
    read -p "" prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
    then
        clear;
        break
    else
        break
    fi
}


function f_installRequirements() {
    echo -e "${Blue}--> install Requirements ${NC}";
    # update :
    sudo apt update && sudo apt upgrade -y && sudo apt autoremove -y && sudo apt clean
    # network-manager
    echo -e "${Orange}--> install network-manager ${NC}";
    sudo apt install -y network-manager
    # netplan.io
    echo -e "${Orange}--> install netplan.io ${NC}";
    sudo apt install -y netplan.io
    # Para verificar si archivo "01-netcfg.yaml" tiene error
    sudo apt install -y yamllint
    # Si no está disponible, reinstala el paquete relacionado:
    sudo apt install -y udev
    # Para que los cambios persistan después de reiniciar, instala el servicio iptables-persistent:
    sudo apt install -y iptables-persistent
    echo -e "${Green}--> END ${NC}";
}


function f_ShowIP() {
    echo -e "${Blue}--> Show IP ${NC}";
    ip addr
    echo -e "${Green}--> END ${NC}";
}


function f_SetupStaticIP() {
    echo -e "${Blue}--> Setup Static IP - Copy 01-netcfg.yaml ${NC}";
    # Copy file
    sudo cp ./dhcp-server/01-netcfg.yaml /etc/netplan/01-netcfg.yaml
    # Si hay errores de formato YAML, Netplan fallará. Puedes validar el formato con:
    sudo yamllint /etc/netplan/01-netcfg.yaml
    # Secure Configuration File Permissions: It’s crucial to ensure that the Netplan configuration file permissions are secure to prevent unauthorized access.
    # This command sets the file permissions so that only the root user can read and write to the file.
    sudo chmod 644 /etc/netplan/01-netcfg.yaml
    # Save changes
    sudo netplan apply
    # Regenerate and apply Netplan Once the file is correctly formatted, apply the configuration:
    # Forzar regeneración de Netplan
    # Si el archivo es correcto pero Netplan no aplica los cambios, intenta regenerar la configuración manualmente:
    sudo netplan generate
    # Aplicar la configuración manualmente
    # Si Netplan sigue sin aplicar los cambios, intenta hacerlo de forma manual en lugar de netplan apply:
    sudo systemctl restart systemd-networkd
    echo -e "${Green}--> END ${NC}";
}


function f_IdentifyNetworkInterface() {
    echo -e "${Blue}--> Identify Your Network Interface ${NC}";
    echo -e "${Orange}--> nmcli d ${NC}";
    # Identify Your Network Interface
    nmcli d
    echo -e "${Green}--> END ${NC}";
}


function f_ShowDefaultRoutes() {
    echo -e "${Blue}--> ip route show ${NC}";
    echo -e "${Orange}--> Verificar de que la IP de eth1 no este en default y que solo este eth0 ${NC}";
    sudo ip route show
    echo -e "${Green}--> END ${NC}";
}


function f_SetDefaultRoutes_Temporary() {
    echo -e "${Blue}--> Se tDefault Routes - Temporary ${NC}";
    # Revisa la puerta de enlace con:
    sudo ip route show
    # Se tDefault Routes - Temporary
    sudo ip route del default dev eth1
    # Revisa la puerta de enlace con:
    sudo ip route show
    # para que sea permanente debes de editar "/etc/netplan/01-netcfg.yaml"
    # y quitar "routes" de "eth1", solo "eth0" debe contener "routes"
    echo -e "${Orange}--> For permanent Remove routes from eth1 in /etc/netplan/01-netcfg.yaml ${NC}";
    echo -e "${Green}--> END ${NC}";
}


function f_InstallKeaDhcpServer() {
    echo -e "${Blue}--> Backup KEA DHCP Server - Copy kea-dhcp4.conf to .bak ${NC}";
    # install curl and apt-transport-https
    echo -e "${Orange}--> install curl and apt-transport-https ${NC}";
    sudo apt install -y curl apt-transport-https
    # --- Add ISC KEA Repository ---
    curl -1sLf 'https://dl.cloudsmith.io/public/isc/kea-2-6/setup.deb.sh' | sudo -E bash
    # After adding the repository, once run the system update command:
    sudo apt update
    # --- Installing KEA DHCP on Ubuntu 24.04 ---
    echo -e "${Orange}--> install isc-kea ${NC}";
    sudo apt install -y isc-kea
    # Check the Version and Service Status
    echo -e "${Orange}--> Check the isc-kea Version ${NC}";
    sudo kea-dhcp4 -version
    echo -e "${Orange}--> Check the isc-kea Service Status ${NC}";
    sudo systemctl status isc-kea-dhcp4-server
    # Enable the DHCPv4 service to start on boot:
    echo -e "${Orange}--> Enable the DHCPv4 service to start on boot ${NC}";
    sudo systemctl enable isc-kea-dhcp4-server
    echo -e "${Green}--> END ${NC}";
}


function f_BackupDhcpServer() {
    echo -e "${Blue}--> Backup KEA DHCP Server - Copy kea-dhcp4.conf to .bak ${NC}";
    sudo mv /etc/kea/kea-dhcp4.conf /etc/kea/kea-dhcp4.conf.bak
    echo -e "${Green}--> END ${NC}";
}


function f_SetupDhcpServer_copy() {
    echo -e "${Blue}--> Setup KEA DHCP Server - Copy kea-dhcp4.conf ${NC}";
    sudo cp ./dhcp-server/kea-dhcp4.conf /etc/kea/kea-dhcp4.conf
    # Let’s validate the configuration file for syntax errors after that we will restart the Kea Service.
    echo -e "${Orange}--> validate the configuration file for syntax errors - kea-dhcp4.conf ${NC}";
    sudo kea-dhcp4 -t /etc/kea/kea-dhcp4.conf
    # Restart the Kea DHCP4 Service: Apply the new configuration by restarting the Kea DHCP4 service:
    echo -e "${Orange}--> restart isc-kea-dhcp4-server ${NC}";
    sudo systemctl restart isc-kea-dhcp4-server.service
    # Check the Service Status: Ensure that the Kea DHCP4 service is running correctly:
    echo -e "${Orange}--> status isc-kea-dhcp4-server ${NC}";
    sudo systemctl status isc-kea-dhcp4-server.service
    echo -e "${Green}--> END ${NC}";
}


function f_allowForwarding() {
    echo -e "${Blue}--> Allow Forwarding ${NC}";
    
    # --- [ Para que los clientes tengan internet ] ---
    # Verificar la configuración de IP forwarding
    # Ubuntu debe permitir el reenvío de paquetes para que los clientes en eth1 puedan acceder a Internet a través de eth0. Activa el reenvío de IP con:
    sudo sysctl -w net.ipv4.ip_forward=1
    
    # Para que el cambio sea persistente, edita /etc/sysctl.conf:
    sudo cp ./dhcp-server/sysctl.conf /etc/sysctl.conf
    
    # Asegúrate de que esta línea esté presente (o agrégala si falta):
    # net.ipv4.ip_forward=1
    
    # Guarda el archivo (Ctrl + X, Y, Enter) y aplica los cambios:
    sudo sysctl -p
    
    # Revisa la puerta de enlace con:
    sudo ip route show
    
    # You need to specify that packets from eth1 should be translated by MASQUERADE. Run:
    # This ensures packets from the LAN network (192.168.1.0/24) get translated through eth0 to access the internet.
    sudo iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE  # Delete previous incorrect rule
    sudo iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE
    
    # Ensure forwarding rules allow traffic
    # Add explicit FORWARD rules:
    # These rules allow forwarding between eth1 (LAN) and eth0 (WAN).
    sudo iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
    sudo iptables -A FORWARD -i eth0 -o eth1 -m state --state RELATED,ESTABLISHED -j ACCEPT
    
    # Make the changes permanent
    # After verifying connectivity, save the rules to persist after reboot:
    sudo netfilter-persistent save

    # IMPORTANTE
    # asegurate de no tener eth1 como default en el route. Para arreglarlo temporalmente:
    # para que sea permanente debes de editar "/etc/netplan/01-netcfg.yaml" y quitar "routes" de "eth1".
    sudo ip route del default dev eth1
    echo -e "${Green}--> END ${NC}";
}


function f_CheckKeaDhcpServiceStatus() {
    echo -e "${Blue}--> Check Service Status ${NC}";
    
    # To check the service and confirm it is running without any error use:
    # For DHCP 4:
    sudo systemctl status isc-kea-dhcp4-server
    # For DHCP 6:
    # sudo systemctl status isc-kea-dhcp6-server
    
    # --- enable the service: ---
    # Enable the DHCPv4 service to start on boot:
    sudo systemctl enable isc-kea-dhcp4-server
    # Enable the DHCPv6 service to start on boot:
    # sudo systemctl enable isc-kea-dhcp6-server
    
    echo -e "${Green}--> END ${NC}";
}

function f_RestartKeaDhcpService() {
    echo -e "${Blue}--> Restart KEA DHCP Service ${NC}";
    # For DHCP 4:
    sudo systemctl restart isc-kea-dhcp4-server
    # For DHCP 6:
    # sudo systemctl restart isc-kea-dhcp6-server
    echo -e "${Green}--> END ${NC}";
}


echo -e "${Orange}";
echo -e "############################################################";
echo -e "#                 Install DHCP Server Script               #";
echo -e "############################################################";
echo -e "${NC}";

MainMenu="Main Menu";
clean="clean";
Exit="Exit and clean";
a1="install Requirements";
a2="Show IP";
a3="Identify Network Interface";
a4="Setup Static IP - Copy 01-netcfg.yaml";
a5="Show Default Routes";
a6="Set Default Routes - Temporary";
a7="Install Kea DHCP Server";
a8="Backup DHCP Server - kea-dhcp4.conf.bak";
a9="Setup DHCP Server - Copy kea-dhcp4.conf";
a10="Allow Forwarding";
a11="Status KEA DHCP Server";
a12="Restart KEA DHCP Server";


PS3="#======= Entrer option #======= :" # this displays the common prompt

options=("${MainMenu}" "${clean}" "${Exit}"
    "${a1}" "${a2}" "${a3}" "${a4}" "${a5}"
    "${a6}" "${a7}" "${a8}" "${a9}"
    "${a10}" "${a11}" "${a12}");

COLUMNS=12;
select opt in "${options[@]}"
do
    case $opt in
        "${MainMenu}")
            f_MainMenu
        ;;
        "${clean}")
            f_clean
        ;;
        "${Exit}")
            f_Exit
        ;;
        "${a1}")
            f_installRequirements
        ;;
        "${a2}")
            f_ShowIP
        ;;
        "${a3}")
            f_IdentifyNetworkInterface
        ;;
        "${a4}")
            f_SetupStaticIP
        ;;
        "${a5}")
            f_ShowDefaultRoutes
        ;;
        "${a6}")
            f_SetDefaultRoutes_Temporary
        ;;
        "${a7}")
            f_InstallKeaDhcpServer
        ;;
        "${a8}")
            f_BackupDhcpServer
        ;;
        "${a9}")
            f_SetupDhcpServer_copy
        ;;
        "${a10}")
            f_allowForwarding
        ;;
        "${a11}")
            f_CheckKeaDhcpServiceStatus
        ;;
        "${a12}")
            f_RestartKeaDhcpService
        ;;
        *) echo "invalid option $REPLY";;
    esac
    COLUMNS=12
done