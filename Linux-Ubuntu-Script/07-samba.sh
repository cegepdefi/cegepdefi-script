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
RED='\033[0;31m' #Color Rouge
Orange='\033[0;33m' #Color Orange
Green='\033[1;32m' #Color Verde
Blue='\033[1;34m' #Color Blue
Purple='\035[1;34m' #Color Purple
Gray='\033[1;36m' #Color Gray
NC='\033[0m' #No Color

echo -e "${Blue}############################################################${NC}";
echo -e "${Blue}#                    Samba Script                          #${NC}";
echo -e "${Blue}############################################################${NC}";

MainMenu="Main Menu";
nettoy="Nettoyer";
Quiter="Quit et clear";
addUser="nmbd addUser";
status="nmbd status";
start="nmbd start";
restart="nmbd restart";
stop="nmbd stop";
enable="nmbd enable";
disable="nmbd disable";

#echo -e "${Blue} Entrer numero option :${NC}";

PS3="#======= Entrer numero option #======= :" # this displays the common prompt

options=("${MainMenu}" "${nettoy}" "${Quiter}" "${addUser}" "${status}" "${start}" "${restart}" "${stop}" "${enable}" "${disable}")

COLUMNS=12
select opt in "${options[@]}"
do
    case $opt in
        "${MainMenu}")
            echo -e "${Blue}--> 01-menu.sh ${NC}";
            exec sudo -u root bash /script/01-menu.sh;
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
        "${addUser}")
            echo -e "${Gray}Next, create a no login local user to access the private share.${NC}";
            echo -e "${Blue}--> sudo useradd -M -s /sbin/nologin sambauser ${NC}";
            echo -e "${Gray}Add the user to the Samba share group created above.${NC}";
            echo -e "${Blue}--> sudo usermod -aG smbshare sambauser ${NC}";
            echo -e "${Gray}Now create an SMB password for the user.${NC}";
            echo -e "${Blue}--> sudo smbpasswd -a sambauser ${NC}";
            echo -e "${Gray}Enable the created account: ${NC}";
            echo -e "${Blue}--> sudo smbpasswd -e sambauser ${NC}";
        ;;
        "${status}")
            echo -e "${Blue}--> status nmbd ${NC}";
            sudo -u root systemctl --no-pager status nmbd;
        ;;
        "${start}")
            echo -e "${Blue}--> start nmbd ${NC}";
            sudo -u root systemctl start nmbd ;
        ;;
        "${restart}")
            echo -e "${Blue}--> restart nmbd ${NC}";
            sudo -u root systemctl restart nmbd ;
        ;;
        "${stop}")
            echo -e "${Blue}--> stop nmbd ${NC}";
            sudo -u root systemctl stop nmbd ;
        ;;
        "${enable}")
            echo -e "${Blue}--> enable nmbd ${NC}";
            sudo -u root systemctl enable nmbd ;
        ;;
        "${disable}")
            echo -e "${Blue}--> disable nmbd ${NC}";
            sudo -u root systemctl disable nmbd ;
        ;;
        *) echo "invalid option $REPLY";;
    esac
done
