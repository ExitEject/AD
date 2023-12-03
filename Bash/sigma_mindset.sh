#!/bin/bash
#requirements: gobuster, gnome-terminal installed, 'default-esr' profile in firefox available
#/usr/share/worslists/dirb/common.txt needs to be present.
#chmod 777 your /etc/hosts, there's probably a more secure way to do this
Help()
{
	#display help
	echo "Syntax: ./sigma.sh [-c | -h]"
	echo "options:"
	echo "-c Cleans up artifacts in ~/Downloads"
	echo "-h displays help"
	}
Bypass()
{
	SigmaMindset
	exit
	}
Clean()
{
	#cleans up artifacts
	rm gobuster.txt
	rm nmap.txt
	rm gobusterfuzz.txt
	echo "Removed artifacts. There will still be a dns entry in /etc/hosts/"
	exit
	}
SigmaMindset()
{
	read -p "Enter IP Address of target" target
 	echo "$target up"
 	curl -X POST "$target" | grep -Eo "(http|https)://[a-zA-Z0-9.?=_%:-]*" > ~/Downloads/$target.txt
    	#curl will pull a POST json from the ip to see if there's a webaddress at :80. Then grep will rip https://~ from the dns and put it in target.txt
	sudo chmod 777 $target.txt
    	sed -r 's/.{7}//' $target.txt > newfile.tmp && mv newfile.tmp $target.txt
    	#sed removes the http:// from the domain name in target.txt, then makes a temp file, then replaces what was in target txt with what was in the tmp file
	IPAddress=$(echo "$target") 
    	DomainName=$(cat "$target.txt")
    	sudo sed -i "4i $IPAddress $DomainName" /etc/hosts
    	#this inserts the ip and domain name into etc/hosts
	command nmap -oN ~/Downloads/nmap.txt -p- --min-rate 1000 -sC -sV $target &
    	command gobuster dir -u $target:80 -w /usr/share/wordlists/dirb/common.txt -x php,pdf,txt,asp -t 100 -o ~/Downloads/gobuster.txt &
	command gobuster fuzz -u http://FUZZ.$target -w /usr/share/wordlists/dirb/subdomains-top1million-5000.txt -o ~/Downloads/gobusterfuzz.txt &
    	#runs three background commands, they will be overwritten if the command is run again preventing a ton of artifacts
	firefox -P 'default-esr' http://$target:80 https://$target:443
    	#opens firefox to 80 and 443 just to check it out
	rm $target.txt
	}
while getopts ":hcb" option; do
	case $option in
	h) #display help
		Help
		exit;;
  	b) #bypass ping probe
   		Bypass;;
	c) #clean up artifacts
		Clean;;
	\?) # Invalid option
		echo "Error: Invalid option"
		exit;;
	esac
done
#this is basically legion but stupid, dont make fun of me
{
	read -p "Enter IP Address of target" target
	#$target is the ip address of the host you want to scan
	if ping -c 1 $target 2>/dev/null; then
	#if ping succeeds then this stuff will happen
		SigmaMindset
	else
		echo "$target down or is not responding to ping probes use -b switch to bypass and run anyways, ensure IP address is correct, and you are on the correct network"
	fi
} 
#HTB Testing Tool
#version 1.411
#created by ExitEject 11/28/2023
