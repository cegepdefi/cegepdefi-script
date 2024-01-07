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

echo -e "${Gray}";
echo -e "############################################################";
echo -e "#                    Basic Commands Script                 #";
echo -e "############################################################";
echo -e "${NC}";

MainMenu="Main Menu";
nettoy="Nettoyer";
Quiter="Quit et clear";
a1="Ping Google 2 fois";
a2="Update";
a3="Upgrade";
a4="Update et Upgrade";
a5="Display Linux distro version";
a6="Display processor architecture";

#echo -e "${Blue} Entrer numero option :${NC}";

PS3="#======= Entrer numero option #======= :" # this displays the common prompt

options=("${MainMenu}" "${nettoy}" "${Quiter}" "${a1}" "${a2}" "${a3}" "${a4}" "${a5}" "${a6}");

COLUMNS=12;
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
