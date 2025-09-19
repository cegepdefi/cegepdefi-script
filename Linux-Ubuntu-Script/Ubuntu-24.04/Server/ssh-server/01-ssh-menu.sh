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



DIR_PATH=""; path_array=""; len="";
function getPath()
{
    # Get the absolute path of the current script
    SCRIPT_PATH="$(realpath "$0")";
    # Get the directory path only (excluding the script filename)
    DIR_PATH="$(dirname "$SCRIPT_PATH")";
    # Split the path into an array using '/' as delimiter
    IFS='/' read -r -a path_array <<< "$DIR_PATH";
    # Get the number of elements in the array
    len=${#path_array[@]};
}
getPath;


prev_dir_full_path="";
function getPrevPath()
{
    # Get the previous directory names
    prev_dir="${path_array[$((len - 2))]}";
    # Construct the full path of the previous directory
    prev_dir_full_path="$(dirname "$DIR_PATH")";
    if false; then
        # Print the previous directory name
        echo "Previous directory: $prev_dir";
        # Print the full path of the previous directory
        echo "Full path of previous directory: $prev_dir_full_path";
    fi
}
getPrevPath


function f_MainMenu()
{
    echo -e "${Blue}--> 01-Server-menu.sh ${NC}";
    exec bash ${prev_dir_full_path}/01-Server-menu.sh;
    echo -e "${Green}--> END ${NC}";
}


function f_Clear()
{
    echo -e "${Blue}--> Clear ${NC}";
    clear;
    PS3="" # this hides the prompt
    COLUMNS=12;
    echo asdf | select foo in "${options[@]}"; do break; done # dummy select
    PS3="#======= Entrer numero option #======= : " # this displays the common prompt
}


function f_Exit()
{
    echo -e "${Blue}--> Nettoyer ? Y / N ${NC}";
    read -p "" prompt
    if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
    then
        clear;
        break
    else
        break
    fi
}


function f_Status()
{
    echo -e "${Blue}--> systemctl status networking ${NC}";
    sudo -u root systemctl --no-pager status ssh;
}


function f_Restart()
{
    echo -e "${Blue}--> systemctl restart networking ${NC}";
    sudo -u root systemctl restart ssh;
}


function f_Start()
{
    echo -e "${Blue}--> systemctl start networking ${NC}";
    sudo -u root systemctl start ssh;
}


function f_Stop()
{
    echo -e "${Blue}--> systemctl stop networking ${NC}";
    sudo -u root systemctl stop ssh;
}


function f_Enable()
{
    echo -e "${Blue}--> systemctl enable networking ${NC}";
    sudo -u root systemctl enable ssh;
}


function f_Disable()
{
    echo -e "${Blue}--> systemctl disable networking ${NC}";
    sudo -u root systemctl disable ssh;
}


echo -e "${Blue}";
echo -e "############################################################";
echo -e "#                               Menu                       #";
echo -e "############################################################";
echo -e "${NC}";

MainMenu="Main Menu";
Clear="Clear";
Exit="Exit + Clear";
a1="status ssh";
a2="restart ssh";
a3="start ssh";
a4="stop ssh";
a5="enable ssh";
a6="disable ssh";

PS3="#======= Entrer numero option #======= :" # this displays the common prompt

options=("${MainMenu}" "${Clear}" "${Exit}" "${a1}" "${a2}" "${a3}" "${a4}" "${a5}" "${a6}")

COLUMNS=12
select opt in "${options[@]}"
do
    case $opt in
        "${MainMenu}")
            f_MainMenu
        ;;
        "${Clear}")
            f_Clear
        ;;
        "${Exit}")
            f_Exit
        ;;
        "${a1}")
            f_Status
        ;;
        "${a2}")
            f_Restart
        ;;
        "${a3}")
            f_Start
        ;;
        "${a4}")
            f_Stop
        ;;
        "${a5}")
            f_Enable
        ;;
        "${a6}")
            f_Disable
        ;;
        *) echo "invalid option $REPLY";;
    esac
done
