#!/bin/bash
NK="\033[36m[ ]\033[0m"
K="\033[36m[\033[31mx\033[36m]\033[0m"
#echo -e "\033[40m\033[32m==================================================\033[0m"
clear
tput cup 28 7
echo -e "\033[33m--[[\033[34m Working on ... \033[33m]]--\033[0m"
tput cup 29 0
echo -e "\033[40m\033[32m==========================================\033[0m"
tput cup 30 0
echo -e "\033[33m Check operating system\033[0m"
echo -e "\033[33m Check init system\033[0m"
echo -e "\033[33m Set user\033[0m"
echo -e "\033[33m Set grooups\033[0m"
echo -e "\033[33m Set visudo\033[0m"
echo -e "\033[33m Set gpg\033[0m"
echo -e "\033[33m Set ssh\033[0m"
echo -e "\033[33m Set firewall rules\033[0m"
echo -e "\033[33m Install Zen Kernel\033[0m"
echo -e "\033[33m Install Distrobox\033[0m"
echo -e "\033[33m Install Cubic\033[0m"
echo -e "\033[33m Install Custom Fonts\033[0m"
echo -e "\033[33m Install Backgrounds\033[0m"
echo -e "\033[33m Set up user specific Environment\033[0m"
echo -e "\033[33m Install and configure xxxxxxxx \033[0m"
echo -e "\033[33m Install and configure xxxxxxxx \033[0m"
echo -e "\033[33m Install and configure xxxxxxxx \033[0m"
echo -e "\033[33m Install and configure xxxxxxxx \033[0m"
echo -e "\033[33m Install and configure xxxxxxxx \033[0m"
tput cup 49 0
echo -e "\033[40m\033[32m==========================================\033[0m"
# check when scripts compleats tasks
tput cup 30 38
echo -e "$NK"
tput cup 31 38
echo -e "$NK"
tput cup 32 38
echo -e "$NK"
tput cup 33 38
echo -e "$NK"
tput cup 34 38
echo -e "$NK"
tput cup 35 38
echo -e "$NK"
tput cup 36 38
echo -e "$NK"
tput cup 37 38
echo -e "$NK"
tput cup 38 38
echo -e "$NK"
tput cup 39 38
echo -e "$NK"
tput cup 40 38
echo -e "$NK"
tput cup 41 38
echo -e "$NK"
tput cup 42 38
echo -e "$NK"
tput cup 43 38
echo -e "$NK"
tput cup 44 38
echo -e "$NK"
tput cup 45 38
echo -e "$NK"
tput cup 46 38
echo -e "$NK"
tput cup 47 38
echo -e "$NK"
tput cup 48 38
echo -e "$NK"
tput cup 50 0
for i in $(seq 29 47)
do
	sleep 0.5
	tput cup $(( i += 1 )) 38
	echo -e $K
done
tput cup 50 0

