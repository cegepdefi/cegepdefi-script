#!/bin/bash

# chmod +x proxmox_firewall.sh
# ./proxmox_firewall.sh

function show_current_firewall_rules() {
    echo "Current Firewall Rules:"
    pve-firewall list
}

function check_custom_rules_status() {
    echo "Checking Custom Security Rules Status..."
    if pve-firewall status | grep -q "enabled"; then
        echo "Custom Security Rules: ENABLED"
    else
        echo "Custom Security Rules: DISABLED"
    fi
}

function enable_custom_rules() {
    echo "Enabling Custom Security Rules..."
    pve-firewall enable
    echo "Custom Security Rules ENABLED."
}

function disable_custom_rules() {
    echo "Disabling Custom Security Rules..."
    pve-firewall disable
    echo "Custom Security Rules DISABLED."
}

function view_in_out_programs() {
    echo "List of programs or services using IN/OUT ports and protocols:"
    ss -tunlp | awk 'NR>1 {print $1, $2, $5, $6}'
}

function check_blocked_port_usage() {
    echo "Checking if any program is trying to use a blocked port..."
    blocked_ports=$(pve-firewall rules | grep DROP | awk '{print $2}')
    for port in $blocked_ports; do
        if ss -tunlp | grep -q ":$port"; then
            echo "Program trying to use blocked port $port:"
            ss -tunlp | grep ":$port"
        fi
    done
}

echo "Proxmox Firewall Management Script"
echo "1. Show Current Firewall Rules"
echo "2. Check Custom Security Rules Status"
echo "3. Enable Custom Security Rules"
echo "4. Disable Custom Security Rules"
echo "5. View IN/OUT Ports and Protocols"
echo "6. Check Blocked Port Usage"
echo "7. Exit"

read -p "Select an option (1-7): " choice

case $choice in
    1) show_current_firewall_rules ;;
    2) check_custom_rules_status ;;
    3) enable_custom_rules ;;
    4) disable_custom_rules ;;
    5) view_in_out_programs ;;
    6) check_blocked_port_usage ;;
    7) echo "Exiting script."; exit ;;
    *) echo "Invalid option. Try again."; exit ;;
esac
