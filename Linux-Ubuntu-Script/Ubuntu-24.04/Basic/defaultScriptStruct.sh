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

function f_clear() {
    echo -e "${Orange}--> [Clear] <--${NC}"
    clear
    PS3="" # this hides the prompt
    COLUMNS=12
    echo asdf | select foo in "${options[@]}"; do break; done # dummy select
    PS3="#======= Entrer numero option #======= : "           # this displays the common prompt
}

function f_Exit() {
    # INPUT
    echo -e "${Orange}--> [Quiter] <--${NC}"
    echo -e "${Gray}[INPUT]${NC}${RED} Clear? (Y/N): ${NC}"
    read -p "" respuesta
    # Convertir la respuesta a minúsculas
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" = "y" ]; then
        clear
        exit
        break
    else
        break
    fi
}

echo -e "${Blue}############################################################${NC}"
echo -e "${Blue}#                          Menu                            #${NC}"
echo -e "${Blue}############################################################${NC}"

Clear="Clear"
Exit="Exit + Clear"

PS3="#======= Entrer numero option #======= :" # this displays the common prompt
options=("${Clear}" "${Exit}")

COLUMNS=12
select opt in "${options[@]}"; do
    case $opt in
    "${Clear}")
        f_clear
        ;;
    "${Exit}")
        f_Exit
        ;;
    *) echo "invalid option $REPLY" ;;
    esac
    COLUMNS=12
done
