#!/bin/bash
clear
echo -e "\033[40m\033[33m=======================================================\033[0m"
tput cup 3 0
echo -e "\033[40m\033[33m=======================================================\033[0m"
tput cup 1 0
echo -e "\033[36mPlease enter \033[34mUser Name     : \033[0m"
echo -e "\033[36mPlease enter \033[34mUser Password : \033[0m"
tput cup 1 30
read USER
tput cup 2 30
read password


if [[ "$password" == "Ba7an?12982" ]]; then
tput cup 5 0
	echo -e "\033[36mWould you like t run the script\n
\033[31m[\033[36mi\033[31m]\033[36mnteractively \033[34mor\033[36m \033[31m[\033[36md\033[31m]\033[36mefault\033[0m"
read -n1 bat
if [[ $bat == "i|I" ]];
then
	sudo bash main.1.form.sh
else
	sudo bash main.3.batan.all.sh
fi


fi
	sudo bash main.1.form.sh

