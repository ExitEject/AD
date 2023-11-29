#!/bin/bash
echo this is basically legion but stupid, dont make fun of me
read -p "Enter IP Address of target " target
if ping -c 1 $target 2>/dev/null; then
    echo "$target up"
    terminal -e nmap -sV -A $target
    terminal -e gobuster dir -u $target:80 -w /usr/share/wordlists/dirb/common.txt
    firefox http://$target:80
    firefox http://$target:443
else
    echo "$target down"
fi
#for VERYLOUD HTB testing
#created by ExitEject 11/28/2023