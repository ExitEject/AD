#!/bin/bash
echo this is basically legion but stupid, dont make fun of me
read -p "Enter IP Address of target" target
if ping -c 1 $target 2>/dev/null; then
    echo "$target up"
    gnome-terminal --bash -c "nmap -oN ~/Downloads/nmap.txt -sC -sV -A $target; exec bash"
    gnome-terminal --bash -c "gobuster dir -u $target:80 -w /usr/share/wordlists/dirb/common.txt -x php -o ~/Downloads/gobuster.txt; exec bash"
    firefox -P 'default-esr' http://$target:80 https://$target:443
else
    echo "$target down"
fi
#for VERYLOUD HTB testing
#created by ExitEject 11/28/2023