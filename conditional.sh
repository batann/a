##########################################################
#{{{ CONDITIONAL                                       ###
##########################################################
clear
echo -e "\033[40m\033[32m---------------------------------------------------------------\033[m"
tput cup 39 4
echo -e "${Pu}Visudo Groups     ${Re}:${N}"
tput cup 40 4
echo -e "${Pu}GPG Keys          ${Re}:${N}"
tput cup 41 4
echo -e "${Pu}SSH Keys          ${Re}:${N}"
tput cup 42 4
echo -e "${Pu}Firewall          ${Re}:${N}"
tput cup 43 4
echo -e "${Pu}Samba             ${Re}:${N}"
tput cup 44 4
echo -e "${Pu}MiniDLNA          ${Re}:${N}"
tput cup 45 4
echo -e "${Pu}None Apt          ${Re}:${N}"
tput cup 46 4
echo -e "${Pu}Lamp Stack        ${Re}:${N}"
tput cup 47 4
echo -e "${Pu}xxxxxxxxxx        ${Re}:${N}"
tput cup 48 4
echo -e "${Pu}xxxxxxxxxx        ${Re}:${N}"
tput cup 50 0
echo -e "\033[40m\033[32m==============================================================\033[m"


tput cup 39 29
echo -e "${Re}>>>${Gr}"
tput cup 39 34
read -n1  aa1
if [[ "$aa1" == "1" ]]; then
	tput cup 39 34
	echo -e "${Wh}Yes"
else
	tput cup 39 34
	echo -e "${Wh}No"
fi


tput cup 40 29
echo -e "${Re}>>>${Gr}"
tput cup 40 34
read -n1 aa2
if [[ "$aa2" == "1" ]]; then
	tput cup 40 34
	echo -e "${Wh}Yes"
else
	tput cup 40 34
	echo -e "${Wh}No"
fi

tput cup 41 29
echo -e "${Re}>>>${Gr}"
tput cup 41 34
read -n1 aa3
if [[ "$aa3" == "1" ]]; then
	tput cup 41 34
	echo -e "${Wh}Yes"
else
	tput cup 41 34
	echo -e "${Wh}No"
fi

tput cup 42 29
echo -e "${Re}>>>${Gr}"
tput cup 42 34
read -n1  aa4
if [[ "$aa4" == "1" ]]; then
	tput cup 42 34
	echo -e "${Wh}Yes"
else
	tput cup 42 34
	echo -e "${Wh}No"
fi

tput cup 43 29
echo -e "${Re}>>>${Gr}"
tput cup 43 34
read -n1  aa5
if [[ "$aa5" == "1" ]]; then
	tput cup 43 34
	echo -e "${Wh}Yes"
else
	tput cup 43 34
	echo -e "${Wh}No"
fi

tput cup 44 29
echo -e "${Re}>>>${Gr}"
tput cup 44 34
read -n1  aa6
if [[ "$aa6" == "1" ]]; then
	tput cup 44 34
	echo -e "${Wh}Yes"
else
	tput cup 44 34
	echo -e "${Wh}No"
fi

tput cup 45 29
echo -e "${Re}>>>${Gr}"
tput cup 45 34
read -n1  aa7
if [[ "$aa7" == "1" ]]; then
	tput cup 45 34
	echo -e "${Wh}Yes"
else
	tput cup 45 34
	echo -e "${Wh}No"
fi

tput cup 46 29
echo -e "${Re}>>>${Gr}"
tput cup 46 34
read -n1  aa8
if [[ "$aa8" == "1" ]]; then
	tput cup 46 34
	echo -e "${Wh}Yes"
else
	tput cup 46 34
	echo -e "${Wh}No"
fi

tput cup 47 29
echo -e "${Re}>>>${Gr}"
tput cup 47 34
if [[ "$aa9" == "1" ]]; then
	tput cup 47 34
	echo -e "${Wh}Yes"
else
	tput cup 47 34
	echo -e "${Wh}No"
fi
clear



