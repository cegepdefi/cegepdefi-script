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
echo -e "${Blue}#               ${RED}[root]${Blue} install packages Script             #${NC}";
echo -e "${Blue}############################################################${NC}";

MainMenu="Main Menu";
nettoy="Nettoyer";
Quiter="Quit et clear";
etherwake="Installer etherwake";
wakeonlan="Install wakeonlan";

#echo -e "${Blue} Entrer numero option :${NC}";

PS3="#======= Entrer numero option #======= :" # this displays the common prompt

options=("${MainMenu}" "${nettoy}" "${Quiter}" "${etherwake}" "${wakeonlan}")

COLUMNS=12
select opt in "${options[@]}"
do
    case $opt in
        "${MainMenu}")
            echo -e "${Blue}--> 01-menu.sh ${NC}";
            exec sudo -u root bash ./01-menu.sh;
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
        "${etherwake}")
            echo -e "${Blue}--> apt-get install -y etherwake ${NC}";
            echo -e "${Blue}--> sudo etherwake <mac address> ${NC}";
            apt-get install -y etherwake ;
        ;;
        "${wakeonlan}")
            echo -e "${Blue}--> apt-get install -y wakeonlan ${NC}";
            echo -e "${Blue}--> sudo wakeonlan <mac address> ${NC}";
            apt-get install -y wakeonlan ;
        ;;
        *) echo "invalid option $REPLY";;
    esac
done
