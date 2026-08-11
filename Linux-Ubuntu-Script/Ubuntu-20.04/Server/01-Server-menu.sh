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



DIR_PATH=""; path_array=""; len="";
function getPath()
{
    # Get the absolute path of the current script
    SCRIPT_PATH="$(realpath "$0")";
    # Get the directory path only (excluding the script filename)
    DIR_PATH="$(dirname "$SCRIPT_PATH")";
    # Split the path into an array using '/' as delimiter
    IFS='/' read -r -a path_array <<< "$DIR_PATH";
    # Get the number of elements in the array
    len=${#path_array[@]};
}
getPath;


prev_dir_full_path="";
function getPrevPath()
{
    # Get the previous directory names
    prev_dir="${path_array[$((len - 2))]}";
    # Construct the full path of the previous directory
    prev_dir_full_path="$(dirname "$DIR_PATH")";
    if false; then
        # Print the previous directory name
        echo "Previous directory: $prev_dir";
        # Print the full path of the previous directory
        echo "Full path of previous directory: $prev_dir_full_path";
    fi
}
getPrevPath


last_dir_full_path="";
function getCurrentPath()
{
    # Get the last directory names
    last_dir="${path_array[$((len - 1))]}";
    # Construct the full path of the last directory
    last_dir_full_path="$(dirname "$SCRIPT_PATH")";
    if false; then
        # Print the last directory name
        echo "Last directory: $last_dir";
        # Print the full path of the last directory
        echo "Full path of previous directory: $last_dir_full_path";
    fi
}
getCurrentPath;


echo -e "${RED}";
echo -e "############################################################";
echo -e "#                       Server Script                      #";
echo -e "############################################################";
echo -e "${NC}";

MainMenu="Main Menu";
nettoy="Nettoyer";
Quiter="Quit et clear";
FTP="FTP Server"; # es hackeable
SSH="SSH Server"; # es hackeable
Samba="Samba Server"; # es hackeable
SMTP="SMTP Server"; # es hackeable
SNMP="SNMP Server"; # es muy hackeable
DNS="DNS Server";
DHCP="DHCP Server";
VNC="VNC Server";
OpenVPN="OpenVPN Server";
Proxy="Proxy Server";
Apache="Apache Server";
AdGuard="AdGuard Home Server";

#CURRENT_SCRIPT_PATH="${BASH_SOURCE[0]}";
#PATH=$(dirname "$CURRENT_SCRIPT_PATH");

PS3="#======= Entrer numero option #======= :" # this displays the common prompt

options=("${MainMenu}" "${nettoy}" "${Quiter}" "${FTP}" "${SSH}" "${Samba}" "${SMTP}" "${SNMP}" "${DNS}" "${DHCP}" "${VNC}" "${OpenVPN}" "${Proxy}" "${Apache}" "${AdGuard}")

COLUMNS=12
select opt in "${options[@]}"
do
    case $opt in
        "${MainMenu}")
            echo -e "${Blue}--> 01-menu.sh ${NC}";
            exec bash ${prev_dir_full_path}/01-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${nettoy}")
            echo -e "${Blue}--> nettoyer ${NC}";
            clear;
            PS3="" # this hides the prompt
            COLUMNS=12;
            echo asdf | select foo in "${options[@]}"; do break; done # dummy select
            PS3="#======= Entrer numero option #======= : " # this displays the common prompt
        ;;
        "${Quiter}")
            echo -e "${Blue}--> Nettoyer ? Y / N ${NC}";
            read -p "" prompt
            if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
            then
                clear;
                break
            else
                break
            fi
        ;;
        "${FTP}")
            echo -e "${Blue}--> FTP Server ${NC}";
            exec bash ${last_dir_full_path}/ftp-server/01-ftp-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${SSH}")
            echo -e "${Blue}--> SSH Server ${NC}";
            exec bash ${last_dir_full_path}/ssh-server/01-ssh-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${Samba}")
            echo -e "${Blue}--> Samba Server ${NC}";
            exec bash ${last_dir_full_path}/samba-server/01-samba-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${SMTP}")
            echo -e "${Blue}--> SMTP Server ${NC}";
            exec bash ${last_dir_full_path}/smtp-server/01-smtp-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${SNMP}")
            echo -e "${Blue}--> SNMP Server ${NC}";
            exec bash ${last_dir_full_path}/snmp-server/01-snmp-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${DNS}")
            echo -e "${Blue}--> DNS Server ${NC}";
            exec bash ${last_dir_full_path}/dns-server/01-dns-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${DHCP}")
            echo -e "${Blue}--> DHCP Server ${NC}";
            exec bash ${last_dir_full_path}/dhcp-server/01-dhcp-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${VNC}")
            echo -e "${Blue}--> VNC Server ${NC}";
            exec bash ${last_dir_full_path}/vnc-server/01-vnc-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${OpenVPN}")
            echo -e "${Blue}--> OpenVPN Server ${NC}";
            exec bash ${last_dir_full_path}/openvpn-server/01-openvpn-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${Proxy}")
            echo -e "${Blue}--> Proxy Server ${NC}";
            exec bash ${last_dir_full_path}/proxy-server/01-proxy-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${Apache}")
            echo -e "${Blue}--> Apache Server ${NC}";
            exec bash ${last_dir_full_path}/apache-server/01-apache-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${AdGuard}")
            echo -e "${Blue}--> AdGuard Home Server ${NC}";
            exec bash ${last_dir_full_path}/adguard-server/01-adguard-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        *) echo "invalid option $REPLY";;
    esac
done