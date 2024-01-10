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
    fi
}

function f_info() {
    echo -e "${Orange}--> [INFO] <--${NC}"
    echo -e "${Blue}LINK: https://github.com/AlessandroZ/LaZagne${NC}"
    echo
    cat <<EOF
- The LaZagne project is an open source application used to 
retrieve lots of passwords stored on a local computer.

- Each software stores its passwords using different techniques
(plaintext, APIs, custom algorithms, databases, etc.).

- This tool has been developed for the purpose of finding
these passwords for the most commonly-used software.

- This project has been added to pupy as a post-exploitation module.

- Python code will be interpreted in memory without touching the disk
and it works on Windows and Linux host.
EOF
    echo
}

function f_Descargar_LaZagne() {
    echo -e "${Orange}--> [Download LaZagne] <--${NC}"
    echo -e "${Blue}LINK: https://github.com/AlessandroZ/LaZagne${NC}"

    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} Download LaZagne? (Y/N): ${NC}"
    read -p "" respuesta

    # Convertir la respuesta a minúsculas
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" = "y" ]; then
        echo -e "${Gray}[COMMAND] sudo apt-get install -y git ${NC}"
        sudo apt-get install -y git

        link="https://github.com/AlessandroZ/LaZagne.git"
        echo -e "${Gray}[COMMAND] git clone $link ${NC}"
        git clone $link

        echo -e "${Gray}[COMMAND] ls ./ ${NC}"
        ls ./
    fi
}

function f_instalarRequisitosPara_LaZagne() {
    echo -e "${Orange}--> [Install LaZagne requirement] <--${NC}"

    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} Install LaZagne requirements? (Y/N): ${NC}"
    read -p "" respuesta

    # Convertir la respuesta a minúsculas
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" = "y" ]; then
        echo -e "${Gray}[COMMAND] ls ./LaZagne ${NC}"
        ls ./LaZagne

        echo -e "${Gray}[COMMAND] pip install -r ./LaZagne/requirements.txt ${NC}"
        pip install -r ./LaZagne/requirements.txt
    fi
}

function f_scan_LaZagne() {
    echo -e "${Orange}--> [Scan - LaZagne] <--${NC}"
    echo -e "${Blue}LINK: https://github.com/AlessandroZ/LaZagne${NC}"

    # INPUT
    echo -e "${Gray}[INPUT]${NC}${RED} Scan to find password? (Y/N): ${NC}"
    read -p "" respuesta

    # Convertir la respuesta a minúsculas
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]')
    if [ "$respuesta" = "y" ]; then
        echo -e "${Gray}[COMMAND] ls ./LaZagne/Linux ${NC}"
        ls ./LaZagne/Linux

        echo -e "${Gray}[COMMAND] python3 ./LaZagne/Linux/laZagne.py all ${NC}"
        python3 ./LaZagne/Linux/laZagne.py all
    fi
}

echo -e "${Blue}############################################################${NC}"
echo -e "${Blue}#                          Menu                            #${NC}"
echo -e "${Blue}############################################################${NC}"

Clear="Clear"
Exit="Exit + Clear"
info="Info - LaZagne"
downloadLaZagne="Download - LaZagne"
requirementLaZagne="Install requirement - LaZagne"
scan1="Linux scan all - LaZagne"

PS3="#======= Entrer numero option #======= :" # this displays the common prompt
options=("${Clear}" "${Exit}" "${info}" "${downloadLaZagne}" "${requirementLaZagne}" "${scan1}")

COLUMNS=12
select opt in "${options[@]}"; do
    case $opt in
    "${Clear}")
        f_clear
        ;;
    "${Exit}")
        f_Exit
        ;;
    "${info}")
        f_info
        ;;
    "${downloadLaZagne}")
        f_Descargar_LaZagne
        ;;
    "${requirementLaZagne}")
        f_instalarRequisitosPara_LaZagne
        ;;
    "${scan1}")
        f_scan_LaZagne
        ;;
    *) echo "invalid option $REPLY" ;;
    esac
    COLUMNS=12
done
