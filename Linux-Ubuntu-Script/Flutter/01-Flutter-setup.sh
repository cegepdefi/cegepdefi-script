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

function f_limpiar_pc() {
    echo "-[COMMAND] sudo apt-get clean && sudo apt-get autoclean && sudo apt autoremove"
    sudo apt-get clean && sudo apt-get autoclean && sudo apt autoremove
}

function f_install_requirements() {
    echo "-LINK: https://docs.flutter.dev/get-started/install/linux"
    sudo apt-get install -y wget curl git snapd unzip zip xz-utils

    echo "-[COMMAND] sudo apt install libglu1-mesa"
    sudo apt install libglu1-mesa -y

    echo "-This will install the Mesa implementation of the OpenGL Utility Library. You can verify that the library is installed by running:"
    ldconfig -p | grep libGLU
    echo "-You should see something like this:"
    echo "--> libGLU.so.1 (libc6,x86-64) => /usr/lib/x86_64-linux-gnu/libGLU.so.1"
    echo "-If you still get the error message after installing the library,"
    echo "-you may need to restart your terminal or log out and log back in for the changes to take effect."

    sudo apt-get install -y snapd
    sudo systemctl enable snapd.service
    sudo systemctl restart snapd.service
    sudo systemctl status snapd.service
    # sudo snapd install notes
    f_limpiar_pc
    sudo reboot
}

function f_install_flutter_snapd() {
    echo "-Method 1: Install Flutter using snapd"
    sudo snap install flutter --classic

    echo "-Note: After you install Flutter with snapd, display your Flutter SDK path with the following command:"
    flutter sdk-path
    f_limpiar_pc
}

function f_verificar_install_doctor() {
    echo "-Verify your install with flutter doctor"
    echo "-After installing Flutter, run flutter doctor."
    flutter doctor

    echo "-To get greater detail on what you need to fix, add the -v flag:"
    flutter doctor -v
}

function f_install_vscode() {
    sudo wget https://vscode.download.prss.microsoft.com/dbazure/download/stable/8b3775030ed1a69b13e4f4c628c612102e30a681/code_1.85.2-1705561292_amd64.deb
    sudo apt install -y ./code_1.85.2-1705561292_amd64.deb
}

function f_install_flutter_vscode_extencion() {
    echo "LINK: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter"
    echo "vscode:extension/Dart-Code.flutter"
    vscode:extension/Dart-Code.flutter
}

function f_install_chrome() {
    echo "Install Google Chrome"
    echo "LINK: https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
    sudo wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install -y google-chrome-stable_current_amd64.deb
}

function f_install_AndroidStudio() {
    echo "Bibliotecas requeridas para máquinas de 64 bits"
    sudo apt-get install -y libc6:i386 libncurses5:i386 libstdc++6:i386 lib32z1 libbz2-1.0:i386

    echo "extract .tar.gz file"
    tar -xvzf android-studio-2023.1.1.28-linux.tar.gz

    echo "Mover el folder android-studio a /opt/"
    sudo mv android-studio /opt/

    echo "install android studio"
    sudo chmod +x /opt/android-studio/bin/studio.sh
    sudo /opt/android-studio/bin/studio.sh
}

function f_disk_space() {
    echo "Show available disk space"

    echo "[COMMAND] sudo df -h"
    sudo df -h

    echo "[COMMAND] sudo df -h /home"
    sudo df -h /home
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
