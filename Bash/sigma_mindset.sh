#!/bin/bash
echo this is basically legion but stupid, dont make fun of me
# help
Help()
{
	#display help
	echo "Syntax: ./sigma.sh [-c | h]"
	echo "options:"
	echo "-c Cleans up artifacts in /etc/hosts and in ~/Downloads"
	echo "-h displays help"
	}
Clean()
{
	#cleans up artifacts
	rm gobuster.txt
	rm nmap.txt
	echo "Removed artifacts. There will still be a dns entry in /etc/hosts/"
	exit
}	
while getopts ":hc" option; do
	case $option in
	h) #display help
		Help
		exit;;
	c) #clean up artifacts
		Clean;;
	\?) # Invalid option
		echo "Error: Invalid option"
		exit;;
	esac
done
read -p "Enter IP Address of target" target
  if ping -c 1 $target 2>/dev/null; then
    	echo "$target up"
    	curl -X POST "$target" | grep -Eo "(http|https)://[a-zA-Z0-9.?=_%:-]*" > ~/Downloads/$target.txt
    	sudo chmod 777 $target.txt
    	sed -r 's/.{7}//' $target.txt > newfile.tmp && mv newfile.tmp $target.txt
    	A=$(echo "$target") 
    	#>> $target.txt
    	B=$(cat "$target.txt")
    	sudo sed -i "4i $A $B" /etc/hosts
    	gnome-terminal -- bash -c  "nmap -oN ~/Downloads/nmap.txt -p- --min-rate 1000 -sC -sV $target"
    	gnome-terminal -- bash -c  "gobuster dir -u $target:80 -w /usr/share/wordlists/dirb/common.txt -x php -o ~/Downloads/gobuster.txt"
    firefox -P 'default-esr' http://$target:80 https://$target:443
    	rm $target.txt
else
    echo "$target down"
fi
#for VERYLOUD HTB testing
#version 1.4 added help and clean option for artifacts
#created by ExitEject 11/28/2023
