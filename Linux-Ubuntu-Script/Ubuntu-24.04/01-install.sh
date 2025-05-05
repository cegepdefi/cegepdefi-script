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


echo -e "${Orange}";
echo -e "############################################################";
echo -e "#                     Install Script                       #";
echo -e "############################################################";
echo -e "${NC}";

MainMenu="Main Menu";
clean="clean";
Quiter="Exit and clean";
a1="DHCP Server";
a2="Code Server";


PS3="#======= Entrer option #======= :" # this displays the common prompt

options=("${MainMenu}" "${clean}" "${Quiter}" "${a1}" "${a2}");

COLUMNS=12;
select opt in "${options[@]}"
do
    case $opt in
        "${MainMenu}")
            echo -e "${Blue}--> 00-menu.sh ${NC}"
            exec sudo -u root bash ./00-menu.sh
            echo -e "${Green}--> END ${NC}"
        ;;
        "${clean}")
            echo -e "${Blue}--> clean ${NC}";
            clear;
            PS3="" # this hides the prompt
            COLUMNS=12;
            echo asdf | select foo in "${options[@]}"; do break; done # dummy select
            PS3="#======= Entrer option #======= : " # this displays the common prompt
        ;;
        "${Quiter}")
            echo -e "${Blue}--> clean ? Y / N ${NC}";
            read -p "" prompt
            if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
            then
                clear;
                break
            else
                break
            fi
        ;;
        "${a1}")
            echo -e "${Blue}--> bash ./dhcp-server/dhcp-server.sh ${NC}";
            exec bash ./dhcp-server/dhcp-server.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${a2}")
            echo -e "${Blue}--> bash ./code-server/code-server.sh ${NC}";
            exec bash ./code-servercode-server.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        *) echo "invalid option $REPLY";;
    esac
    COLUMNS=12
done