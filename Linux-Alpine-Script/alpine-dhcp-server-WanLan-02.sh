#!/bin/bash

# install sudo
# apk add --update sudo

# create a user
# adduser admin

# add the new user to sudoers
# echo "admin ALL=(ALL) ALL" > /etc/sudoers.d/admin && chmod 0440 /etc/sudoers.d/admin 

# Install DHCP Server:
# Install the DHCP server package using the Alpine package manager (apk):
apk add dhcp

# instalar iptable
apk add iptables

# Configure WAN interface (eth0)
# Edit the network interface configuration files for eth0 (WAN) and eth1 (LAN):
# echo 'auto eth0
# iface eth0 inet dhcp' > /etc/network/interfaces.d/eth0

echo 'auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 192.168.1.1
    netmask 255.255.255.0' > /etc/network/interfaces

# Configure LAN interface (eth1)
# echo 'auto eth1
# iface eth1 inet static
    # address 192.168.1.1
    # netmask 255.255.255.0' > /etc/network/interfaces.d/eth1

# Configure DHCP server
# Edit the DHCP server configuration file (/etc/dhcp/dhcpd.conf) to define your DHCP settings. For example:
echo 'subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.10 192.168.1.100;
    option routers 192.168.1.1;
    option broadcast-address 192.168.1.255;
    option domain-name-servers 8.8.8.8, 8.8.4.4;
    default-lease-time 600;
    max-lease-time 7200;
}' > /etc/dhcp/dhcpd.conf

# Enable IP forwarding
# Create a sysctl configuration file to enable IP forwarding:
echo 'net.ipv4.ip_forward=1' > /etc/sysctl.d/ip_forward.conf
sysctl -p /etc/sysctl.d/ip_forward.conf

# Enable NAT (Network Address Translation) for internet access
# Replace eth0 with your WAN interface.
echo '#!/bin/sh
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE' > /etc/network/if-pre-up.d/iptables
chmod +x /etc/network/if-pre-up.d/iptables

# Verifica iptables:
# Una vez que la instalación esté completa, intenta nuevamente ejecutar el comando:
iptables -t nat -L -n -v

# El resultado debe de ser :
# ahora si funciona se ven los resultados, creo que el problema era que tenia que reiniciar la maquina virtual alpine "el servidor dhcp" despues de haber instalado iptables.
# ahora el resultado que me da es:
# Chain POSTROUTING (policy ACCEPT 1 packets, 48 bytes)
#  pkts bytes target     prot opt in     out     source               destination         
    # 0     0 MASQUERADE  all  --  *      eth0    0.0.0.0/0            0.0.0.0/0           
    # 0     0 MASQUERADE  all  --  *      eth0    0.0.0.0/0            0.0.0.0/0           
    # 0     0 MASQUERADE  all  --  *      eth0    0.0.0.0/0            0.0.0.0/0


# Save Iptables Rules:
# Save the iptables rules using the rc-service command:
rc-service iptables save



# Sin esto los clientes no tendran internet (el comando no es permanente)
# https://serverfault.com/questions/525671/computer-gets-ip-from-dhcp-server-but-has-no-internet-connection
sysctl -w net.ipv4.ip_forward=1

# hacer ese comando permanente
echo "net.ipv4.ip_forward=1" > /etc/sysctl.conf


# Start DHCP server
# Enable and start the DHCP server service using the Alpine init system:
rc-update add dhcpd
rc-service dhcpd start

# Ensure Network Configuration Persists:
# You can use the openrc-save command to ensure network configuration persists across reboots:
# openrc-save network

echo "DHCP server setup complete."

# Reboot:
# Reboot the system to ensure that the changes persist after a restart:
reboot
