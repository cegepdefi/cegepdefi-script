#!/bin/bash

# Función para mostrar las interfaces disponibles
show_interfaces() {
    echo "Interfaces disponibles:"
    ip -o link show | awk -F': ' '{print $2}'
}

# Función para configurar IP estática en la interfaz seleccionada
set_static_ip() {
    echo "Selecciona la interfaz LAN (para el servidor DHCP):"
    show_interfaces
    read -p "LAN interface: " LAN_IFACE
    read -p "IP estática para LAN (ej: 192.168.1.1): " LAN_IP

    # Configurar Netplan
    NETPLAN_FILE="/etc/netplan/01-dhcp-config.yaml"
    echo "network:" > $NETPLAN_FILE
    echo "  version: 2" >> $NETPLAN_FILE
    echo "  ethernets:" >> $NETPLAN_FILE
    echo "    $LAN_IFACE:" >> $NETPLAN_FILE
    echo "      dhcp4: no" >> $NETPLAN_FILE
    echo "      addresses: [$LAN_IP/24]" >> $NETPLAN_FILE
    echo "      gateway4: 192.168.1.1" >> $NETPLAN_FILE
    echo "      nameservers:" >> $NETPLAN_FILE
    echo "        addresses: [8.8.8.8, 8.8.4.4]" >> $NETPLAN_FILE

    # Aplicar configuración
    netplan apply
}

# Función para instalar el servidor DHCP
install_dhcp() {
    echo "Instalando Kea DHCP Server..."
    apt update
    apt install -y kea
}

# Función para configurar Kea DHCP
setup_dhcp() {
    echo "Configurando Kea DHCP Server..."
    KEA_CONF="/etc/kea/kea-dhcp4.conf"
    echo "Selecciona la interfaz LAN para el servidor DHCP:"
    show_interfaces
    read -p "LAN interface: " LAN_IFACE

    cat <<EOF > $KEA_CONF
{
  "Dhcp4": {
    "interfaces-config": {
      "interfaces": ["$LAN_IFACE"]
    },
    "subnet4": [
      {
        "subnet": "192.168.1.0/24",
        "pools": [{"pool": "192.168.1.100 - 192.168.1.200"}],
        "option-data": [
          {"name": "routers", "data": "192.168.1.1"},
          {"name": "domain-name-servers", "data": "8.8.8.8, 8.8.4.4"}
        ]
      }
    ]
  }
}
EOF

    systemctl restart kea-dhcp4
}

# Función para configurar NAT y permitir acceso a Internet
setup_nat() {
    echo "Selecciona la interfaz WAN (conectada a Internet):"
    show_interfaces
    read -p "WAN interface: " WAN_IFACE

    echo "Configurando NAT para acceso a Internet..."
    sysctl -w net.ipv4.ip_forward=1
    iptables -t nat -A POSTROUTING -o $WAN_IFACE -j MASQUERADE
    iptables -A FORWARD -i $LAN_IFACE -o $WAN_IFACE -j ACCEPT
    iptables -A FORWARD -i $WAN_IFACE -o $LAN_IFACE -m state --state RELATED,ESTABLISHED -j ACCEPT
    netfilter-persistent save
}

# Menú interactivo
while true; do
    echo -e "\nMenú de configuración DHCP"
    echo "1. Mostrar interfaces de red"
    echo "2. Configurar IP estática"
    echo "3. Instalar servidor DHCP"
    echo "4. Configurar servidor DHCP"
    echo "5. Configurar NAT para acceso a Internet"
    echo "6. Ver estado del servidor DHCP"
    echo "7. Reiniciar servidor DHCP"
    echo "8. Iniciar servidor DHCP"
    echo "9. Detener servidor DHCP"
    echo "10. Habilitar inicio automático DHCP"
    echo "11. Deshabilitar inicio automático DHCP"
    echo "12. Salir"
    read -p "Selecciona una opción: " OPTION

    case $OPTION in
        1) show_interfaces ;;
        2) set_static_ip ;;
        3) install_dhcp ;;
        4) setup_dhcp ;;
        5) setup_nat ;;
        6) systemctl status kea-dhcp4 ;;
        7) systemctl restart kea-dhcp4 ;;
        8) systemctl start kea-dhcp4 ;;
        9) systemctl stop kea-dhcp4 ;;
        10) systemctl enable kea-dhcp4 ;;
        11) systemctl disable kea-dhcp4 ;;
        12) echo "Saliendo..."; exit ;;
        *) echo "Opción inválida" ;;
    esac
done
