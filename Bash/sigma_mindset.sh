#!/bin/bash
#requirements: gobuster, gnome-terminal installed, 'default-esr' profile in firefox available
#/usr/share/worslists/dirb/common.txt needs to be present.
#chmod 777 your /etc/hosts, there's probably a more secure way to do this
echo this is basically legion but stupid, dont make fun of me
read -p "Enter IP Address of target" target
#$target is the ip address of the host you want to scan
if ping -c 1 $target 2>/dev/null; then
#if ping succeeds then this stuff will happen
    echo "$target up"
    curl -X POST "$target" | grep -Eo "(http|https)://[a-zA-Z0-9.?=_%:-]*" > ~/Downloads/$target.txt
    #curl will pull a POST json from the ip to see if there's a webaddress at :80. Then grep will rip https://~ from the dns and put it in target.txt
    sudo chmod 777 $target.txt
    #chmod makes the txt file editable
    sed -r 's/.{7}//' $target.txt > newfile.tmp && mv newfile.tmp $target.txt
    #sed removes the http:// from the dns in target.txt, then makes a temp file, then replaces what was in target txt with what was in the tmp file
    A=$(echo "$target")
    B=$(cat "$target.txt")
    #creates variables one with the ip and one with dns thats been cleaned up
    sudo sed -i "4i $A $B" /etc/hosts
    #this inserts the ip and dns into etc/hosts
    gnome-terminal -- bash -c "nmap -oN ~/Downloads/nmap.txt -p- --min-rate 1000 -sC -sV $target"
    gnome-terminal -- bash -c "gobuster dir -u $target:80 -w /usr/share/wordlists/dirb/common.txt -x php -o ~/Downloads/gobuster.txt"
    #opens two terminals with nmap and gobuster runs and then saves two files for later review, they will be overwritten if the command is run again preventing a ton of artifacts
    firefox -P 'default-esr' http://$target:80 https://$target:443
    #opens firefox to 80 and 443 just to check it out
     rm $target.txt 
     #cleans up left over article
else
    echo "$target down"
fi
#this is a very noisy script, i made it to help me automate some of my initial pentesting
#this is not for stealth
#v1.032 included comments explaining stuff
#created by ExitEject 11/28/2023