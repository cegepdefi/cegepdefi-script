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
echo -e "${Blue}#                Fire-Wall Script                          #${NC}";
echo -e "${Blue}############################################################${NC}";
echo -e " ";
echo -e "${Blue}############################################################${NC}";
echo -e "${RED}#        DONT RUN [ufw enable] !!!!                         #${NC}";
echo -e "${Orange}#        First of all add the port 22 to the rules          #${NC}";
echo -e "${Green}#        sudo ufw allow 22                                  #${NC}";
echo -e "${Blue}############################################################${NC}";

MainMenu="Main Menu";
nettoy="Nettoyer";
Quiter="Quit et clear";
deleteRule="delete rules";
ufwallow="add rule portNumber (ufw allow)";
ufwdeny="add rule portNumber (ufw deny)";
ufwallowFromIp="sudo ufw allow from ipNumber";
a1="ufw status";
a2="ufw status verbose";
a3="ufw status numbered";
a4="ufw enable";
a5="ufw disable";
defaultInst="Reset firewall to installation defaults";
iptablesAccept="iptables ACCEPT";
iptablesDrop="iptables DROP";
clearAll="clear all currently configured rules (sudo iptables -F)";
listDefaultFirewallApp="list default firewall rules";


#echo -e "${Blue} Entrer numero option :${NC}";

PS3="#======= Entrer numero option #======= :" # this displays the common prompt

options=("${MainMenu}" "${nettoy}" "${Quiter}" "${deleteRule}" "${ufwallow}" "${ufwdeny}" "${ufwallowFromIp}" "${a1}" "${a2}" "${a3}" "${a4}" "${a5}" "${defaultInst}" "${iptablesAccept}" "${iptablesDrop}" "${clearAll}" "${listDefaultFirewallApp}")

COLUMNS=12
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
        "${deleteRule}")
            echo -e "${Blue}--> ufw status numbered ${NC}";
            sudo -u root ufw status numbered ;
            echo -e "${Orange}--> delete rules using the command:${RED} ufw delete NUM ${NC}";
            echo -e "${Orange}--> Where NUM is the rule numbered. ${NC}";
            read -p 'Enter the port number: ' numPortDelete
            sudo -u root ufw delete $numPortDelete;
        ;;
        "${ufwallow}")
            echo -e "${Blue}--> ufw status numbered ${NC}";
            sudo -u root ufw status numbered ;
            read -p 'Enter the port number: ' numPortAdd
            echo -e "${Blue}--> ufw allow ${RED}$numPortAdd ${NC}";
            sudo -u root ufw allow $numPortAdd;
        ;;
        "${ufwdeny}")
            echo -e "${Blue}--> ufw status numbered ${NC}";
            sudo -u root ufw status numbered ;
            read -p 'Enter the port number: ' numPortDeny
            echo -e "${Blue}--> ufw allow ${RED}$numPortDeny ${NC}";
            sudo -u root ufw deny $numPortDeny;
        ;;
        "${ufwallowFromIp}")
            echo -e "${Blue}--> ufw status numbered ${NC}";
            sudo -u root ufw status numbered ;
            read -p 'Enter the other PC ip address : ' numIp
            echo -e "${Blue}--> ufw allow ${RED}$numIp ${NC}";
            sudo -u root ufw allow from $numIp;
        ;;
        "${a1}")
            echo -e "${Blue}--> ufw status ${NC}";
            sudo -u root ufw status ;
        ;;
        "${a2}")
            echo -e "${Blue}--> ufw status verbose ${NC}";
            sudo -u root ufw status verbose ;
        ;;
        "${a3}")
            echo -e "${Blue}--> ufw status numbered ${NC}";
            sudo -u root ufw status numbered ;
        ;;
        "${a4}")
            echo -e "${Blue}--> ufw enable ${NC}";
            sudo -u root ufw enable ;
        ;;
        "${a5}")
            echo -e "${Blue}--> ufw disable ${NC}";
            sudo -u root ufw disable ;
        ;;
        "${defaultInst}")
            echo -e "${Blue}--> ufw reset ${NC}";
            sudo -u root ufw reset ;
        ;;
        "${iptablesAccept}")
            echo -e "${Blue}--> ufw reset ${NC}";
            sudo -u root ufw reset ;
        ;;
        "${iptablesDrop}")
            echo -e "${RED}--> block all of the IP addresses in the ip/24 network range.${NC}";
            echo -e "${Blue}--> sudo -u root iptables -A INPUT -s 192.168.0.0/24 -j DROP ${NC}";
            sudo -u root iptables -A INPUT -s 192.168.0.0/24 -j DROP;
            echo -e "${RED}--> block SSH connections from any IP address ${NC}";
            echo -e "${Blue}--> sudo -u root iptables -A INPUT -p tcp --dport ssh -j DROP ${NC}";
            sudo -u root iptables -A INPUT -p tcp --dport ssh -j DROP;
            echo -e "${RED}--> Saving Changes ${NC}";
            echo -e "${Blue}--> sudo -u root /sbin/iptables-save ${NC}";
            sudo -u root /sbin/iptables-save;
            sudo -u root /etc/init.d/iptables save;
            echo -e "${RED}--> List the currently configured iptables rules: ${NC}";
            echo -e "${Blue}--> sudo -u root iptables -L ${NC}";
            sudo -u root iptables -L;
        ;;
        "${clearAll}")
            echo -e "${RED}--> To clear all the currently configured rules, you can issue the flush command.${NC}";
            echo -e "${Blue}--> sudo -u root iptables -F ${NC}";
            sudo -u root iptables -F;
        ;;
        "${listDefaultFirewallApp}")
            echo -e "${RED}--> List the currently configured iptables rules: ${NC}";
            echo -e "${Blue}--> sudo -u root iptables -L ${NC}";
            sudo -u root iptables -L;
        ;;
        *) echo "invalid option $REPLY";;
    esac
done
