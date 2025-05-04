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

echo -e "${Orange}";
echo -e "############################################################";
echo -e "#                     Main Script                          #";
echo -e "############################################################";
echo -e "${NC}";

nettoy="Nettoyer";
Quiter="Quit et clear";
a1="02-BasicCommand.sh";
a2="03-net.sh";
a3="04-ssh.sh";
a4="05-install.sh";
firewall="06-fire-wall.sh";
samba="07-samba.sh";
wakeonlan="08-wakeonlan.sh";

#echo -e "${Blue} Entrer numero option :${NC}";

PS3="#======= Entrer numero option #======= :" # this displays the common prompt

options=("${nettoy}" "${Quiter}" "${a1}" "${a2}" "${a3}" "${a4}" "${firewall}" "${samba}" "${wakeonlan}");

COLUMNS=12;
select opt in "${options[@]}"
do
    case $opt in
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
            echo -e "${Blue}--> bash ./02-BasicCommand.sh ${NC}";
            exec bash ./02-BasicCommand.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${a2}")
            echo -e "${Blue}--> bash ./03-net.sh ${NC}";
            exec bash ./03-net.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${a3}")
            echo -e "${Blue}--> bash ./04-ssh.sh ${NC}";
            exec bash ./04-ssh.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${a4}")
            echo -e "${Blue}--> bash ./05-install.sh ${NC}";
            exec bash ./05-install.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${firewall}")
            echo -e "${Blue}--> 06-fire-wall.sh ${NC}";
            exec bash ./06-fire-wall.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${samba}")
            echo -e "${Blue}--> 07-samba.sh ${NC}";
            exec bash ./07-samba.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        "${wakeonlan}")
            echo -e "${Blue}--> 08-wakeonlan.sh ${NC}";
            exec bash ./08-wakeonlan.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        *) echo "invalid option $REPLY";;
    esac
    COLUMNS=12
done
