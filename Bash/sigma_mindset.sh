#!/bin/bash
echo this is basically legion but stupid, dont make fun of me
read -p "Enter IP Address of target" target
if ping -c 1 $target 2>/dev/null; then
    echo "$target up"
    curl -X POST "$target" | grep -Eo "(http|https)://[a-zA-Z0-9.?=_%:-]*" > ~/Downloads/$target.txt
    sudo chmod 777 $target.txt
    sed -r 's/.{7}//' $target.txt > newfile.tmp && mv newfile.tmp $target.txt
    A=$(echo "$target")
    B=$(cat "$target.txt")
    sudo sed -i "4i $A $B" /etc/hosts
    gnome-terminal -- bash -c "nmap -oN ~/Downloads/nmap.txt -p- --min-rate 1000 -sC -sV $target"
    gnome-terminal -- bash -c "gobuster dir -u $target:80 -w /usr/share/wordlists/dirb/common.txt -x php -o ~/Downloads/gobuster.txt"
    firefox -P 'default-esr' http://$target:80 https://$target:443
     rm $target.txt 
else
    echo "$target down"
fi
#for VERYLOUD HTB testing
#v1.031 fixed a wrong command on 10, changed to echo
#created by ExitEject 11/28/2023