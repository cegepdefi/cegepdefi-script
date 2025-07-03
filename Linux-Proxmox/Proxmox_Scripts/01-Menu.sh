#!/bin/bash

# chmod +x 01-Menu.sh
# ./01-Menu.sh

function my_clean_externalDisk() {
    echo "my_clean_externalDisk:"
    source ./my_clean_externalDisk.sh
}
function my_clean_systemDisk() {
    echo "my_clean_systemDisk:"
    source ./my_clean_systemDisk.sh
}
function my_defrag() {
    echo "my_defrag:"
    source ./my_defrag.sh
}
function my_delete_externalDisk_Directory() {
    echo "my_delete_externalDisk_Directory:"
    source ./my_delete_externalDisk_Directory.sh
}
function proxmox_firewall() {
    echo "proxmox_firewall:"
    source ./proxmox_firewall.sh
}
function Samba() {
    echo "Samba:"
    source ./Samba.sh
}

echo "== [ My Proxmox Scripts ] =="
echo "1. my_clean_externalDisk.sh"
echo "2. my_clean_systemDisk.sh"
echo "3. my_defrag.sh"
echo "4. my_delete_externalDisk_Directory.sh"
echo "5. proxmox_firewall.sh"
echo "6. Samba.sh"
echo "7. Exit"

read -p "Select an option (1-7): " choice

case $choice in
    1) my_clean_externalDisk ;;
    2) my_clean_systemDisk ;;
    3) my_defrag ;;
    4) my_delete_externalDisk_Directory ;;
    5) proxmox_firewall ;;
    6) Samba ;;
    7) echo "Exiting script."; exit ;;
    *) echo "Invalid option. Try again."; exit ;;
esac