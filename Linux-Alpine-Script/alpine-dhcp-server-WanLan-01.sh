#!/bin/bash

# Install DHCP server package
apk add dhcp

# Configure WAN interface (eth0)
cat << EOF > /etc/network/interfaces.d/eth0
auto eth0
iface eth0 inet dhcp
EOF

# Configure LAN interface (eth1)
cat << EOF > /etc/network/interfaces.d/eth1
auto eth1
iface eth1 inet static
    address 192.168.1.1
    netmask 255.255.255.0
EOF

# Configure DHCP server
cat << EOF > /etc/dhcp/dhcpd.conf
option domain-name "example.com";
option domain-name-servers 8.8.8.8;

default-lease-time 600;
max-lease-time 7200;

subnet 192.168.1.0 netmask 255.255.255.0 {
    range 192.168.1.10 192.168.1.100;
    option routers 192.168.1.1;
    option broadcast-address 192.168.1.255;
    default-lease-time 600;
    max-lease-time 7200;
}
EOF

# Enable IP forwarding
echo "net.ipv4.ip_forward=1" > /etc/sysctl.d/ip_forward.conf
sysctl -p /etc/sysctl.d/ip_forward.conf

# Enable NAT (Network Address Translation) for internet access
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Start DHCP server
rc-service dhcpd start

# Save iptables rules
rc-service iptables save

echo "DHCP server setup complete."
