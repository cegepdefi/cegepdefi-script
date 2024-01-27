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

function f_instalar_dhcp() {
    echo -e "${Orange}--> [Install DHCP Server] <--${NC}"
    sudo apt update
    sudo apt install -y isc-dhcp-server
}

function f_desinstalar_dhcp() {
    echo -e "${Orange}--> [Uninstall DHCP Server] <--${NC}"
    sudo apt remove -y isc-dhcp-server
}

function f_mostrar_interfaces() {
    # Obtener una lista de todas las interfaces de red disponibles. Mostrar interfaces y direcciones IP.
    echo "interfaces y direcciones IP"
    interfaces=$(ip -o link show | awk -F': ' '{print $2}')
    for iface in $interfaces; do
        ip_addr=$(ip -o -4 addr show $iface | awk '{print $4}')
        echo "$iface - $ip_addr"
    done
    echo
}

# Esto se llama desde otra funcion
function mostrar_ejemplo_configuracion() {
    f_mostrar_interfaces
    echo "Ejemplo de configuración con dos interfaces (WAN y LAN):"
    echo "Contenido del archivo /etc/network/interfaces"

    cat <<EOF
auto lo
iface lo inet loopback

auto tu_interfaz_WAN
iface tu_interfaz_WAN inet static
    address 192.168.1.2  # IP estática de la interfaz WAN
    netmask 255.255.255.0
    gateway 192.168.1.1  # Puerta de enlace para la interfaz WAN

auto tu_interfaz_LAN
iface tu_interfaz_LAN inet static
    address 192.168.2.1  # IP estática de la interfaz LAN
    netmask 255.255.255.0
EOF
    echo
    echo "La primera carta de red (WAN) se encarga de darle internet al Servidor DHCP"
    echo "La segunda carta de red (LAN) se encarga de colocar ip dinamicas a los clientes"
    echo "En el archivo de configuracion es importante poner el subnet, netmask, etc.. en la misma red que la (LAN)"
    echo "En este ejemplo ambos (LAN) y el archivo config dhcp deben de estar en 192.168.2.X y 255.255.255.0"
    echo
}

# Esto se llama desde otra funcion
function f_mostrar_ejemplos() {
    echo -e "${Orange}--> [DHCP Ejemplo] <--${NC}"
    mostrar_ejemplo_configuracion

    echo "Ejemplo de configuración DHCP:"
    echo "Contenido del archivo /etc/dhcp/dhcpd.conf"
    echo -e "${Gray}[COMMAND] sudo nano /etc/dhcp/dhcpd.conf ${NC}"
    cat <<EOF
    subnet 192.168.2.0 netmask 255.255.255.0 {
        range 192.168.2.10 192.168.2.50;
        option routers 192.168.2.1;
        option domain-name-servers 8.8.8.8, 8.8.4.4;
    }
EOF
    echo
}

# Configuración adicional para habilitar el enrutamiento en el servidor DHCP
function f_configurar_enrutamiento() {
    echo -e "${Orange}--> [Configurando enrutamiento] <--${NC}"
    echo "Esto permitira hacer que los clientes tengan internet"
    echo

    f_mostrar_interfaces

    # Obtener una lista de todas las interfaces de red disponibles
    interfaces_disponibles=($(ip link | grep -oP '(?<=\d: )[^: ]+'))

    # Preguntar al usuario cuál interfaz es la WAN
    echo "Seleccione la interfaz WAN:"
    select wan_interface in "${interfaces_disponibles[@]}"; do
        break
    done

    # Preguntar al usuario cuál interfaz es la LAN
    echo "Seleccione la interfaz LAN:"
    select lan_interface in "${interfaces_disponibles[@]}"; do
        break
    done

    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} ¿Deseas instalar netfilter-persistent? (Y/N): ${NC}"
    read -p "" respuesta
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if ["$respuesta" == "y"]; then
        sudo apt-get update
        sudo apt-get install iptables-persistent
    fi

    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} ¿Deseas configurar el enrutamiento para permitir internet a los clientes? (Y/N): ${NC}"
    read -p "" respuesta
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if ["$respuesta" == "y"]; then
        echo "Habilitar el reenvío de IP"
        echo "1" >/proc/sys/net/ipv4/ip_forward
        echo

        echo "Asegurar que los paquetes entre las interfaces se enrutaran"
        sudo iptables -A FORWARD -i $lan_interface -o $wan_interface -j ACCEPT
        sudo iptables -A FORWARD -i $wan_interface -o $lan_interface -j ACCEPT
        echo

        echo "Verificar si la línea ya existe en /etc/sysctl.conf"
        if ! grep -qxF "net.ipv4.ip_forward=1" /etc/sysctl.conf; then
            # Agregar la línea solo si no existe
            echo "net.ipv4.ip_forward=1" | sudo tee -a /etc/sysctl.conf
            sudo sysctl -p
        else
            echo "La configuración ya existe en /etc/sysctl.conf."
        fi

        echo "Configurar el masquerading para que los paquetes salientes parezcan provenir del servidor DHCP"
        sudo iptables -t nat -A POSTROUTING -o $wan_interface -j MASQUERADE
        echo

        echo "Guardar las reglas iptables"
        if [ -x "$(command -v iptables-save)" ]; then
            sudo iptables-save | sudo tee /etc/iptables/rules.v4
            sudo service netfilter-persistent save
            sudo service netfilter-persistent reload
        fi

        echo "Enrutamiento configurado."
        echo
    else
        echo "El enrutamiento no sera configurado..."
    fi
}

function f_configurar_dhcp() {
    echo -e "${Orange}--> [Configure DHCP Server] <--${NC}"

    # INPUT
    echo -e "${Orange}--> [Quiter] <--${NC}"
    echo -e "${Gray}[INPUT]${NC}${RED} ¿Deseas ver ejemplos de configuración? (Y/N): ${NC}"
    read -p "" respuesta
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if ["$respuesta" == "y"]; then
        f_mostrar_ejemplos
    fi

    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} ¿Desea editar el archivo de configuración? (y/n): ${NC}"
    read -p "" respuesta
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" == "y" ]; then
        echo -e "${Gray}[COMMAND] sudo nano /etc/dhcp/dhcpd.conf ${NC}"
        sudo nano /etc/dhcp/dhcpd.conf
    elif [ "$respuesta" == "n" ]; then
        # INPUT
        echo -e "${Gray}[INPUT]${NC}${RED} ¿Desea sobrescribir el archivo de configuración con el ejemplo? (y/n): ${NC}"
        read -p "" sobrescribir
        sobrescribir=$(echo "$sobrescribir" | tr '[:upper:]' '[:lower:]')
        if [ "$sobrescribir" == "y" ]; then
            echo -e "${Gray}[COMMAND] sudo systemctl stop isc-dhcp-server ${NC}"
            sudo systemctl stop isc-dhcp-server
            echo -e "${Gray}[COMMAND] sudo cp ./dhcpd.conf /etc/dhcp/dhcpd.conf ${NC}"
            sudo cp ./dhcpd.conf /etc/dhcp/dhcpd.conf
            echo "Archivo de configuración sobrescrito con el ejemplo."
            echo -e "${Gray}[COMMAND] sudo systemctl restart isc-dhcp-server ${NC}"
            sudo systemctl restart isc-dhcp-server
            echo -e "${Gray}[COMMAND] sudo systemctl status isc-dhcp-server ${NC}"
            sudo systemctl status isc-dhcp-server
        fi
    else
        echo "Respuesta no válida. Opción no reconocida."
    fi
}

function f_verificar_configuracion_dhcp() {
    echo "Verificando la configuración del servidor DHCP..."
    if sudo dhcpd -t; then
        echo "La configuración del servidor DHCP es válida."
    else
        echo "¡Error en la configuración del servidor DHCP!"
        echo "Por favor, revise el archivo de configuración."
    fi
}

function f_verificar_instalacion_dhcp() {
    if dpkg -l | grep -q isc-dhcp-server; then
        echo "El servidor DHCP está instalado."
    else
        echo "El servidor DHCP no está instalado."
    fi
}

function f_verificar_estado_dhcp() {
    if systemctl is-enabled isc-dhcp-server >/dev/null && systemctl is-active isc-dhcp-server >/dev/null; then
        echo "El servidor DHCP está habilitado y en ejecución."
    else
        echo "El servidor DHCP no está habilitado o no está en ejecución."
        f_preguntar_habilitar_dhcp
    fi
}

# Esta funcion no se executa desde el menu. Se llama desde otra funcion.
function f_preguntar_habilitar_dhcp() {
    read -p "¿Desea habilitar y comenzar el servidor DHCP? (y/n): " respuesta
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" == "y" ]; then
        sudo systemctl enable isc-dhcp-server
        sudo systemctl restart isc-dhcp-server
        echo "El servidor DHCP ha sido habilitado y comenzado."
    else
        echo "El servidor DHCP no ha sido habilitado ni comenzado."
    fi
}

function configurar_ip_estaticaB {
    clear
    echo -e "${Gray}[COMMAND] cat /etc/network/interfaces ${NC}"
    cat /etc/network/interfaces

    echo -e "${Gray}[COMMAND] ip addr show ${NC}"
    ip addr show

    echo -e "${Gray}Interfaces de red disponibles: ${NC}"
    interfaces=($(ip addr show | grep "^[0-9]" | awk '{print $2}' | cut -d ":" -f1 | cut -d "@" -f1))

    # Mostrar las opciones disponibles al usuario
    for ((i = 0; i < ${#interfaces[@]}; i++)); do
        echo "$((i + 1)). ${interfaces[$i]}"
    done

    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} Mostrar ejemplo de archivo interfaces? (y/n): ${NC}"
    read -p "" respuesta
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" == "y" ]; then
        echo -e "${Gray}[COMMAND] El archivo es: /etc/network/interfaces ${NC}"
        cat <<EOF
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
address 192.168.2.2
netmask 255.255.255.0
network 192.168.2.0
broadcast 192.168.2.255
gateway 192.168.2.1
EOF
    fi

    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} Modificar el archivo? (y/n): ${NC}"
    read -p "" respuesta
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" == "y" ]; then
        echo -e "${Gray}[COMMAND] sudo nano /etc/network/interfaces ${NC}"
        sudo nano /etc/network/interfaces
    fi

    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} Restart networking? (y/n): ${NC}"
    read -p "" respuesta
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" == "y" ]; then
        echo -e "${Gray}[COMMAND] sudo ip addr flush eth0 && sudo ip addr flush eth1 ${NC}"
        sudo ip addr flush eth0 && sudo ip addr flush eth1
        echo -e "${Gray}[COMMAND] sudo systemctl restart systemd-networkd ${NC}"
        sudo systemctl restart systemd-networkd
    fi
}

function configurar_ip_estatica {
    clear
    echo -e "${Gray}[COMMAND] cat /etc/network/interfaces ${NC}"
    cat /etc/network/interfaces
    echo -e "${Gray}[COMMAND] ip addr show ${NC}"
    ip addr show
    echo -e "${Gray}Interfaces de red disponibles: ${NC}"
    interfaces=($(ip addr show | grep "^[0-9]" | awk '{print $2}' | cut -d ":" -f1 | cut -d "@" -f1))

    # Mostrar las opciones disponibles al usuario
    for ((i = 0; i < ${#interfaces[@]}; i++)); do
        echo "$((i + 1)). ${interfaces[$i]}"
    done

    read -p "Seleccione el número correspondiente a la interfaz de red para configurar la IP estática: " seleccion

    # Validar la selección del usuario
    if [[ ! "$seleccion" =~ ^[0-9]+$ ]] || [ "$seleccion" -lt 1 ] || [ "$seleccion" -gt "${#interfaces[@]}" ]; then
        echo "Selección no válida. Saliendo..."
        exit 1
    fi

    interfaz=${interfaces[$((seleccion - 1))]}

    read -p "Ingrese la dirección IP estática para la interfaz $interfaz (ej. 192.168.1.2): " ip_address

    if [ -z "$ip_address" ]; then
        echo "Dirección IP no válida. Saliendo..."
        exit 1
    fi

    read -p "Ingrese la máscara de red para la interfaz $interfaz (ej. 255.255.255.0): " netmask

    if [ -z "$netmask" ]; then
        echo "Máscara de red no válida. Saliendo..."
        exit 1
    fi

    # Asegúrate de que la interfaz existe
    if [ ! -e "/sys/class/net/$interfaz" ]; then
        echo "La interfaz $interfaz no existe. Saliendo..."
        exit 1
    fi

    # Configura la IP estática
    sudo ip addr flush dev $interfaz
    sudo ip addr add $ip_address/$netmask dev $interfaz

    # Muestra la nueva configuración
    echo "Configuración IP estática para $interfaz:"
    ip addr show $interfaz

    # Guarda la configuración de forma persistente
    echo -e "auto $interfaz\niface $interfaz inet static\naddress $ip_address\nnetmask $netmask" | sudo tee -a /etc/network/interfaces
    sudo systemctl restart networking

    echo "Configuración guardada y aplicada de forma persistente. La interfaz $interfaz ahora tiene la IP estática $ip_address/$netmask."
}

echo -e "${Blue}############################################################${NC}"
echo -e "${Blue}#                          Menu                            #${NC}"
echo -e "${Blue}############################################################${NC}"

Clear="Clear"
Exit="Exit + Clear"
configurarIpEstatica="Configure static ip"
installDhcp="Install DHCP Server"
uninstallDhcp="Uninstall DHCP Server"
configurarDhcp="Configure DHCP Server"
verificarArchivoDhcp="Check if DHCP configuration file contains error"
verificarSiDhcpInstalado="Check if DHCP is installed"
verificarEstadoDhcp="Check if DHCP is enabled and started"

PS3="#======= Entrer numero option #======= :" # this displays the common prompt
options=("${Clear}" "${Exit}"
    "${configurarIpEstatica}"
    "${installDhcp}" "${uninstallDhcp}"
    "${configurarDhcp}" "${verificarArchivoDhcp}"
    "${verificarSiDhcpInstalado}" "${verificarEstadoDhcp}")

COLUMNS=12
select opt in "${options[@]}"; do
    case $opt in
    "${Clear}")
        f_clear
        ;;
    "${Exit}")
        f_Exit
        ;;
    "${configurarIpEstatica}")
        configurar_ip_estaticaB
        ;;
    "${installDhcp}")
        f_instalar_dhcp
        ;;
    "${uninstallDhcp}")
        f_desinstalar_dhcp
        ;;
    "${configurarDhcp}")
        f_configurar_dhcp
        ;;
    "${verificarArchivoDhcp}")
        f_verificar_configuracion_dhcp
        ;;
    "${verificarSiDhcpInstalado}")
        f_verificar_instalacion_dhcp
        ;;
    "${verificarEstadoDhcp}")
        f_verificar_estado_dhcp
        ;;
    *) echo "invalid option $REPLY" ;;
    esac
    COLUMNS=12
done
