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
echo -e "#                     Main Script                          #";
echo -e "############################################################";
echo -e "${NC}";

clean="clean";
Quiter="Exit and clean";
a1="create user with sudo";
a2="01-install.sh";


PS3="#======= Entrer option #======= :" # this displays the common prompt

options=("${clean}" "${Quiter}" "${a1}" "${a2}");

COLUMNS=12;
select opt in "${options[@]}"
do
    case $opt in
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
            echo -e "${Blue}--> Enter the new username: ${NC}";
            read -p "" prompt
            if [[ $prompt == "" ]]
            then
                clear;
                echo -e "${Orange}--> ERROR: username is empty ${NC}";
                break
            else
                echo -e "${Blue}--> adduser $prompt ${NC}";
                adduser $prompt;
                echo -e "${Blue}--> usermod -aG sudo $prompt ${NC}";
                usermod -aG sudo $prompt;
            fi
            echo -e "${Green}--> END ${NC}";
        ;;
        "${a2}")
            echo -e "${Blue}--> bash ./01-install.sh ${NC}";
            exec bash ./01-install.sh;
            echo -e "${Green}--> END ${NC}";
        ;;
        *) echo "invalid option $REPLY";;
    esac
    COLUMNS=12
done