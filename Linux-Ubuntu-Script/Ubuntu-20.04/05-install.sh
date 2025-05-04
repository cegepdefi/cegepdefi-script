#!/bin/bash
#=========== [ Couleur  ON]=======
#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;3
#=========== [ Couleur  OFF]=======
#=========== [ Couleur Example  ON]=======
#RED='\033[0;31m' #Color Rouge
#NC='\033[0m' #No Color
#echo -e "${RED} Salut ${NC}" #afficher text avec couleur
#=========== [ Couleur Example  OFF]=======
RED='\033[0;31m'    #Color Rouge
Orange='\033[0;33m' #Color Orange
Green='\033[1;32m'  #Color Verde
Blue='\033[1;34m'   #Color Blue
Purple='\035[1;34m' #Color Purple
Gray='\033[1;36m'   #Color Gray
NC='\033[0m'        #No Color

echo -e "${Blue}############################################################${NC}"
echo -e "${Blue}#               ${RED}[root]${Blue} install packages Script             #${NC}"
echo -e "${Blue}############################################################${NC}"

MainMenu="Main Menu"
nettoy="Nettoyer"
Quiter="Quit et clear"
sudo="Installer sudo"
nano="Installer nano"
FireWall="Installer Fire-wall"
docker="Installer docker"
portainer="install portainer"
samba="install samba"
apache="install apache"
openssl="install openssl (apache https)"
wordpress="install WordPress"

#echo -e "${Blue} Entrer numero option :${NC}";

PS3="#======= Entrer numero option #======= :" # this displays the common prompt

options=("${MainMenu}" "${nettoy}" "${Quiter}" "${sudo}"
    "${nano}" "${FireWall}" "${docker}"
    "${portainer}" "${samba}" "${apache}" "${openssl}"
    "${wordpress}")

COLUMNS=12
select opt in "${options[@]}"; do
    case $opt in
    "${MainMenu}")
        echo -e "${Blue}--> 01-menu.sh ${NC}"
        exec sudo -u root bash ./01-menu.sh
        echo -e "${Green}--> END ${NC}"
        ;;
    "${nettoy}")
        echo -e "${Blue}--> nettoyer ${NC}"
        clear
        PS3="" # this hides the prompt
        COLUMNS=12
        echo asdf | select foo in "${options[@]}"; do break; done # dummy select
        PS3="#======= Entrer numero option #======= : "           # this displays the common prompt
        ;;
    "${Quiter}")
        echo -e "${Blue}--> Nettoyer ? Y / N ${NC}"
        read -p "" prompt
        if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]; then
            clear
            break
        else
            break
        fi
        ;;
    "${sudo}")
        echo -e "${Blue}--> apt-get install -y sudo ${NC}"
        echo -e "${RED}--> Add user to sudo group : /sbin/adduser username sudo ${NC}"
        echo -e "${RED}--> or : usermod -aG sudo username${NC}"
        apt-get install -y sudo
        ;;
    "${nano}")
        echo -e "${Blue}--> apt-get install -y nano ${NC}"
        apt-get install -y nano
        ;;
    "${FireWall}")
        echo -e "${Blue}--> apt-get install -y ufw ${NC}"
        apt-get install -y ufw
        ;;
    "${docker}")
        echo -e "${Blue}--> Install docker ${NC}"
        echo -e "${Green}-->Link: https://youtu.be/O7G3oatg5DA ${NC}"
        apt-get update -y && apt-get upgrade
        curl -sSL https://get.docker.com | sh
        groupadd docker
        read -p 'Enter the user name for Docker group: ' noUser
        usermod -aG docker $noUser
        newgrp docker
        ;;
    "${portainer}")
        echo -e "${Blue}--> Install docker portainer ${NC}"
        echo -e "${Green}-->Link: https://youtu.be/gXuLiglJceY ${NC}"
        echo -e "${Green}-->Link: https://youtu.be/O7G3oatg5DA?t=316 ${NC}"
        sudo docker pull portainer/portainer-ce:latest
        sudo docker run -d -p 9000:9000 --name=portainer --restart=always -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer-ce:latest
        ;;
    "${samba}")
        echo -e "${Blue}--> Install samba ${NC}"
        apt-get install -y samba smbclient cifs-utils
        groupadd smbshare
        mkdir /www
        mkdir /private
        chmod 2775 -R /www
        chmod 2775 -R /private
        useradd -M -s /sbin/nologin origami
        usermod -aG smbshare origami
        smbpasswd -a origami
        smbpasswd -e origami
        cp /etc/samba/smb.conf /etc/samba/smb.conf.back1
        rm /etc/samba/smb.conf
        cp ./smb.conf /etc/samba/smb.conf
        testparm
        systemctl restart nmbd
        systemctl --no-pager status nmbd
        ;;
    "${apache}")
        echo -e "${Blue}--> apt-get install -y apache2 ${NC}"
        apt-get install -y apache2
        ;;
    "${openssl}")
        echo -e "${Blue}--> apt-get install -y openssl ${NC}"
        apt-get update -y
        apt-get install -y apache2 openssl
        mkdir -p /etc/ssl/mycerts
        openssl req -new -x509 -days 365 -nodes -out /etc/ssl/mycerts/apache.pem -keyout /etc/ssl/mycerts/apache.key
        chmod -R 600 /etc/ssl/mycerts
        echo -e "${RED}--> In /etc/hosts add a new line to match the [DOMAIN NAME] ${NC}"
        echo -e "${RED}--> <YOUR_RASPBERRY_ID>  <DOMAIN NAME>${NC}"
        a2enmod ssl
        rm /etc/apache2/sites-available/default-ssl.conf
        cp ./default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
        a2ensite default-ssl
        service apache2 reload
        ;;
    "${wordpress}")
        echo -e "${Blue}--> bash ./Wordpress/01-wordpress-install.sh ${NC}"
        exec bash ./Wordpress/01-wordpress-install.sh
        ;;
    *) echo "invalid option $REPLY" ;;
    esac
done
