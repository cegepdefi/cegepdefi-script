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

echo -e "${Gray}";
echo -e "############################################################";
echo -e "#                    Basic Commands Script                 #";
echo -e "############################################################";
echo -e "${NC}";

MainMenu="Main Menu";
Clear="Clear";
Exit="Exit and clear";
a1="Ping Google x2";
a2="Update";
a3="Upgrade";
a4="Update and Upgrade";
aptautoremove="apt Autoremove";
aptclean="apt Clean";
a5="Display Linux distro version";
a6="Display processor architecture";

PS3="#======= Enter numero option #======= :" # this displays the common prompt

options=("${MainMenu}" "${Clear}" "${Exit}" 
        "${a1}" "${a2}" "${a3}" "${a4}" "${a5}" "${a6}"
        "${aptautoremove}" "${aptclean}");

COLUMNS=12;
select opt in "${options[@]}"
do
    case $opt in
        "${MainMenu}")
            echo -e "${Blue}--> 01-menu.sh ${NC}";
            exec sudo -u root bash ./01-menu.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${Clear}")
            echo -e "${Blue}--> Clear ${NC}";
            clear;
            PS3="" # this hides the prompt
            COLUMNS=12;
            echo asdf | select foo in "${options[@]}"; do break; done # dummy select
            PS3="#======= Entrer numero option #======= : " # this displays the common prompt
        ;;
        "${Exit}")
            echo -e "${Blue}--> Clear ? Y / N ${NC}";
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
            echo -e "${Blue}--> ping -c 2 8.8.8.8 ${NC}";
            ping -c 2 8.8.8.8;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${a2}")
            echo -e "${Blue}--> apt-get -y Update ${NC}";
            sudo -u root apt-get -y update;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${a3}")
            echo -e "${Blue}--> apt-get -y upgrade ${NC}";
            sudo -u root apt-get -y upgrade;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${a4}")
            echo -e "${Blue}--> apt-get -y update && apt-get -y upgrade ${NC}";
            sudo -u root apt-get -y update && sudo -u root apt-get -y upgrade;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${aptautoremove}")
            echo -e "${Blue}--> apt-get -y autoremove ${NC}";
            sudo -u root apt autoremove -y;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${aptclean}")
            echo -e "${Blue}--> apt-get -y autoremove ${NC}";
            sudo -u root apt clean;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${a5}")
            echo -e "${Blue}--> cat /etc/*-release ${NC}";
            sudo -u root cat /etc/*-release;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${a6}")
            echo -e "${Blue}--> lscpu ${NC}";
            sudo -u root lscpu;
            echo -e "${Green}--> END ${NC}";
        ;;
        *) echo "invalid option $REPLY";;
    esac
    COLUMNS=12
done
