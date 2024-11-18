#{{{#main.3.sh
#!/bin/bash
# vim:fileencoding=utf-8:foldmethod=marker
#}}}
##########################################################
#{{{###   Dependencies                                     ###
##########################################################
DEPENDS=( 'ufw' 'git' 'samba' 'openssh-server' 'openssh-client' 'openssh' 'minidlna' 'pass' 'isync' 'abook' 'neomutt')
###   SET COMMAND TO EXECUTE   ##################
execute_command="sudo apt install -y"

# Function to check if a package is installed
check_package() {
    dpkg -s "$1" &> /dev/null
    if [ $? -ne 0 ]; then
        missing_packages+=("$1")
    fi
}

# Read packages from the file new_file
packages=()
while IFS= read -r line; do
    clean_package=$(echo "$line" | xargs)
    if [[ -n "$clean_package" ]]; then
        packages+=("$clean_package")
    fi
done < "$DEPENDS"


missing_packages=()


# Loop through the list of packages
for package in "${packages[@]}"; do
    check_package "$package"
done

# If there are missing packages, prompt the user to install them
if [ ${#missing_packages[@]} -ne 0 ]; then
    echo -e "${R}The following packages are missing:${N}"
    for pkg in "${missing_packages[@]}"; do
        echo -e "${B}$pkg${N}"
    done

    read -p "Do you want to install all missing packages? (y/n): " choice
    if [ "$choice" == "y" ]; then
        sudo apt update
        sudo apt upgrade -y
        for pkg in "${missing_packages[@]}"; do
            $execute_command $pkg
        done
    else
        echo "Skipping installation of missing packages."
    fi
else
    echo -e "${G}All packages are already installed.${N}"
fi


#}}}
##########################################################
#{{{###   IF BATAN                                         ###
##########################################################

if [[ $USER == "batan" ]];
then







#}}}
##########################################################
#{{{###   Detect OS                                        #
##########################################################
# Check for Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
	if [ -f /etc/os-release ]; then
		# Source the os-release file to get distribution info
		. /etc/os-release
		OS=$NAME
		VER=$VERSION_ID
	elif [ -f /etc/lsb-release ]; then
		# For older systems, use lsb_release if available
		. /etc/lsb-release
		OS=$DISTRIB_ID
		VER=$DISTRIB_RELEASE
	elif [ -f /etc/debian_version ]; then
		# For Debian-based systems without os-release
		OS="Debian"
		VER=$(cat /etc/debian_version)
	else
		# Unknown Linux system
		OS=$(uname -s)
		VER=$(uname -r)
	fi
fi
echo -e "${B}Detected Linux system:$R $OS $VER"


#}}}
##########################################################
#{{{###   Sudo Visudo and GROUPS                           ###
##########################################################
echo "batan ALL=(ALL:ALL) NOPASSWD:ALL"|sudo EDITOR='tee -a' visudo

USER="batan"
# List of groups to check and add
GROUPS=('lp' 'dialout' 'cdrom' 'floppy' 'sudo' 'audio' 'dip' 'video' 'plugdev' 'users' 'netdev' 'lpadmin' 'vboxsf' 'scanner' 'sambashare')

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
	echo "This script must be run as root."
	exit 1
fi
# Check if the user was provided
if [[ -z "$USER" ]]; then
	echo "Usage: $0 <username>"
	exit 1
fi
# Iterate through each group and check if the user is a member
for group in "${GROUPS[@]}"; do
	if groups "$USER" | grep -qw "$group"; then
		echo "User $USER is already in group $group."
	else
		echo "Adding user $USER to group $group."
		usermod -aG "$group" "$USER"
	fi
done
echo -e "${B}Group membership check and update complete for$R $USER."


#}}}
##########################################################
#{{{###   Setup GPG                                        ###
##########################################################
###   Check if GPG is installed   ################################
command -v gpg >/dev/null 2>&1 || { echo >&2 "GPG is not installed. Please install GPG and try again."; exit 1; }
###   Set key details   ##########################################
full_name="fairdinkum batan"
email_address="fairdinkumbatan@gmail.com"
passphrase="Ba7an?12982"
app_password="ixeh bhbn dbrq pbyc"
###   Generate GPG key   #########################################
gpg --batch --full-generate-key <<EOF
	Key-Type: RSA
	Key-Length: 4096
	Subkey-Type: RSA
	Subkey-Length: 4096
	Name-Real: $full_name
	Name-Email: $email_address
	Expire-Date: 1y
	Passphrase: $passphrase
	%commit
EOF

echo "${B}GPG key generation completed.$R Please make sure to remember your passphrase.$N"
read -n1 -p ' Press [any] to Continue ....' abc
pass init fairdinkumbatan@gmail.com
################################################
#}}}
##########################################################
#{{{###   Setup SSH and SSH remote                         ###
##########################################################

key_name="id_rsa"
key_location="$HOME/.ssh/$key_name"
ssh-keygen -t rsa -b 4096 -f "$key_location" -N ""

###   Function to detect the init system   ###########
get_init_system() {
	if [ -f /run/systemd/system ]; then
		echo "systemd"
	elif command -v service >/dev/null; then
		echo "SysVinit"
	elif command -v rc-service >/dev/null; then
		echo "OpenRC"
	elif command -v initctl >/dev/null; then
		echo "Upstart"
	else
		echo "unknown"
	fi
}

###   Function to configure SSH on a remote machine   ###########
configure_ssh() {
	# SSH configuration file path
	local ssh_config="/etc/ssh/sshd_config"
	local init_system=$(get_init_system)  # Detect the init system
	sudo cp $ssh_config "$ssh_config.bak"
	# Combine all SSH configuration changes into one command
	ssh -o "StrictHostKeyChecking=no" -o "PasswordAuthentication=no" "$1" "\
		sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' $ssh_config && \
		sudo sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' $ssh_config && \
		# Restart SSH service based on the detected init system
			$(case "$init_system" in
			systemd) echo "sudo systemctl restart ssh";;
			SysVinit) echo "sudo service ssh restart";;
			OpenRC) echo "sudo rc-service sshd restart";;
			Upstart) echo "sudo stop ssh && sudo start ssh";;
			*) echo "echo 'Unknown init system: $init_system. Cannot restart SSH.'";;
		esac)"
		}

		active_ips=()
		local_ip=$(hostname -I | awk '{print $1}')

		for i in $(seq 35 40); do
			current_ip="192.168.1.$i"
			if [ "$current_ip" != "$local_ip" ] && ping -c 1 -W 1 "$current_ip" &> /dev/null; then
				active_ips+=("$current_ip")
			fi
		done

		for ip in "${active_ips[@]}"; do
			ssh-copy-id -i "$key_location.pub" batan@"$ip"
			configure_ssh "$ip"  # Call the function to configure SSH on the remote machine
		done
		clear
		read -n1 -p '           Press [any] to Continue...'
	#}}}
##########################################################
#{{{###   Firewall                                         ###
##########################################################
for i in $(seq 35 40);
do
	sudo ufw allow from 192.168.1.$i && sudo ufw allow to 192.168.1.$i
done
sudo ufw enable
curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash
sudo grub-mkconfig -o /boot/grub/grub.cfg


#}}}
##########################################################
#{{{###   Samba                                            ###
##########################################################

# Variables
USER="batan"
PASSWORD="Ba7an?12982"
SHARE_DIRS=("/home/batan/Videos" "/home/batan/Music" "/home/batan/Documents" "/home/batan/Pictures")

# Ensure samba service is installed
if ! command -v smbpasswd &> /dev/null; then
	echo "Samba is not installed. Installing now..."
	sudo apt-get install samba -y || sudo pacman -S samba || sudo dnf install samba -y
fi

# Create samba user and set password
echo "Creating Samba user: $USER"
sudo smbpasswd -x $USER &> /dev/null  # Remove the user if they exist already
sudo useradd -M -s /sbin/nologin $USER  # Create system user without home
echo -e "$PASSWORD\n$PASSWORD" | sudo smbpasswd -a $USER  # Set Samba password
sudo smbpasswd -e $USER  # Enable the user

# Backup smb.conf
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Modify smb.conf
echo "Modifying /etc/samba/smb.conf"

for dir in "${SHARE_DIRS[@]}"; do
	sudo mkdir -p "/srv/samba/$dir"
	sudo chown $USER:users "/srv/samba/$dir"
	sudo chmod 755 "/srv/samba/$dir"

	# Add the share configuration
	sudo bash -c cat >> /etc/samba/smb.conf <<EOF

	[$dir]
	path = /srv/samba/$dir
	browseable = yes
	read only = no
	guest ok = no
	valid users = $USER
	write list = $USER
	create mask = 0775
	directory mask = 0775
	public = yes
EOF

done

# Set up read-only access for everyone else
sudo bash -c cat >> /etc/samba/smb.conf <<EOF

[Public]
path = /srv/samba
public = yes
only guest = yes
browseable = yes
writable = no
guest ok = yes
create mask = 0775
directory mask = 0775
EOF
# Restart Samba services
if [[ "$init_system" == "systemd" ]]; then
	sudo systemctl restart smbd
	sudo systemctl enable smbd
else
	sudo service smbd restart
	sudo service smbd enable
fi
echo "Samba setup complete."
#}}}
##########################################################
#{{{###   MiniDLNA                                         ###
##########################################################
# Variables
USER="batan"
HOME_DIR="/home/$USER"
MEDIA_DIRS=("$HOME_DIR/Videos" "$HOME_DIR/Music" "$HOME_DIR/Pictures")
CONFIG_FILE="/etc/minidlna.conf"

# Ensure minidlna is installed
if ! command -v minidlnad &> /dev/null; then
	echo "MiniDLNA is not installed. Installing now..."
	sudo apt-get install minidlna -y || sudo pacman -S minidlna || sudo dnf install minidlna -y
fi

# Backup minidlna.conf
sudo cp $CONFIG_FILE "${CONFIG_FILE}.bak"

# Modify minidlna.conf
echo "Modifying $CONFIG_FILE"
sudo bash -c "cat > $CONFIG_FILE <<EOF
# MiniDLNA configuration

# Set the user that minidlna will run as
user=$USER

# Network interface to bind to (optional)
# interface=eth0

# Media directories
EOF"

for dir in "${MEDIA_DIRS[@]}"; do
	# Adding media directories to config
	sudo bash -c "echo 'media_dir=V,$dir' >> $CONFIG_FILE"
done

sudo bash -c "cat >> $CONFIG_FILE <<EOF

# Path to the log file
log_dir=/var/log

# Port number for HTTP (clients connecting to stream media)
port=8200

# Database location
db_dir=/var/cache/minidlna

# Notify interval (seconds)
notify_interval=900

# Strictly adhere to DLNA standards (yes/no)
strict_dlna=no
EOF"

# Set correct permissions for media directories
for dir in "${MEDIA_DIRS[@]}"; do
	sudo chown -R $USER:users "$dir"
	sudo chmod -R 755 "$dir"
done
# Restart MiniDLNA service
if [[ "$init_system" == "systemd" ]]; then
	sudo systemctl restart minidlna
	sudo systemctl enable minidlna
else
	sudo service minidlna restart
	sudo service minidlna enable
fi
# Force MiniDLNA to rescan media directories
sudo minidlnad -R

echo "MiniDLNA setup complete. Media should now be available on the local network."
#}}}
##########################################################
#{{{###   NONE APT PACKAGES                                ###
##########################################################
   #{{{# BEGINNING
dialog --backtitle "Your friendly Postinstall Script" --title "Hi there!" --msgbox "Hold on to your heameroids and relax,
		dont panic, I am here to help!" 10 60


		if [[ $EUID -ne 0 ]]; then
			echo "This script must be run as root"
			exit 1
		else
			#Update and Upgrade
			echo "Updating and Upgrading"
			#	apt-get update && sudo apt-get upgrade
		fi
		sudo apt-get install dialog -y
		cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 40 76 30)
   #}}}

  # {{{# OPTIONS
 options_non=(1 'zen-kernel' off
		2  'cubic' off
		3  'distrobox' off
		4  'ungoogled-chromium' off
		5  'libre-wolf' off
		6  'i2p' off
		7  'musikcube' off
		8  'oolite' off
		9  'browsh' off
		10 'nix' off
	    11 'bashrun2' off
		12 'heatseeker' off
		13 '' off
		14 '' off
		15 '' off




	)

   #}}}
#   {{{# COMMANDS
choices=$("${cmd[@]}" "${options_non[@]}" 2>&1 >/dev/tty)
	clear
	for choice in $choices
	do
		case $choice in
			1)
				#zen-kernel
				echo "${B}Installing$R Zen-Kernel$N"
				curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash
				sudo update-grub
				;;
			2)
				#cubic
				echo -e "${B}Setting up repositories and installing ${R}Cubic ${B}Dev-Util${N}"
				sudo apt install --no-recommends dpkg
				echo "deb https://ppa.launchpadcontent.net/cubic-wizard/release/ubuntu/ noble main" | sudo tee /etc/apt/sources.list.d/cubic-wizard-release.list
				curl -S "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x081525e2b4f1283b" | sudo gpg --batch --yes --dearmor --output /etc/apt/trusted.gpg.d/cubic-wizard-ubuntu-release.gpg
				sudo apt update
				sudo apt install --no-install-recommends cubic
				;;


			3)
				#distrobox
				echo -e "${B}Installing Dependencies for$R Distrobox$N "
				sudo apt install docker docker-complose docker-cleean podman distrobox
				;;

			4)
				#ungoogled-chromium
				echo "${B}Downloading$R Ungoogled-Chromum$B AppImage$N "
				wget https://github.com/ungoogled-software/ungoogled-chromium-portablelinux/releases/download/129.0.6668.70-1/ungoogled-chromium_129.0.6668.70-1.AppImage
				sudo chmod a+x ungoogled-chromium_129.0.6668.70-1.AppImage
				;;

			5)
				#libre-wolf
				echo -e "${B}Setting up repositories and installing ${R}Libre Wolf ${B}browser${N}"
				missing_packages=()
				for dep in "${dependencies_librewolf[@]}"; do
					if ! check_dependency "$dep"; then
						missing_packages+=("$dep")
						echo "$dep is not installed."
					fi
				done
				# If there are missing packages, ask for confirmation to install
				if [ ${#missing_packages[@]} -gt 0 ]; then
					echo -e ""
					echo -e "\033[34m================================================\033[31m"
					read -n1 -p "Install missing packages? (y/n): " abc
					if [[ "$abc" == "y" || "$abc" == "Y" ]]; then
						echo -e "\033[0m"
						sudo apt-get install -y "${missing_packages[@]}"
					else
						echo "Installation aborted."
					fi
				else
					echo -e "\033[44m\033[30mAll dependencies are installed.\033[0m"
				fi

				distro=$(if echo " una bookworm vanessa focal jammy bullseye vera uma " | grep -q " $(lsb_release -sc) "; then lsb_release -sc; else echo focal; fi)
				wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
				sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
Types: deb
URIs: https://deb.librewolf.net
Suites: $distro
Components: main
Architectures: amd64
Signed-By: /usr/share/keyrings/librewolf.gpg
EOF
sudo apt update
sudo apt install librewolf -y
;;


6)
	#i2p
	echo -e "${B}Downloading and installing ${R}i2p+ openjdk-17-jre ${B}${N}"
	wget https://i2pplus.github.io/installers/i2pinstall_2.6.0+.exe
	wget http://ftp.au.debian.org/debian/pool/main/o/openjdk-17/openjdk-17-jre_17.0.12+7-2~deb12u1_amd64.deb
	sudo dpkg -i openjdk-17-jre_17.0.12+7-2~deb12u1_amd64.deb
	java -jar ./i2pinstall_2.6.0+.exe


	;;
7)
	#musikcube
	echo -e "${B}Downloading and installing ${R}Musikcube ${B}player${N}"
	wget https://github.com/clangen/musikcube/releases/download/3.0.4/musikcube_3.0.4_linux_x86_64.deb

	sudo dpkg -i musikcube_3.0.4_linux_x86_64.deb
	sudo apt-get install -f



	;;
8)
	#oolite
	echo -e "${B}Downloading and installing ${R}Oolite Oolitestarter ${B}${N}"
	echo "Installing "
	wget https://github.com/OoliteProject/oolite/releases/download/1.90/oolite-1.90.linux-x86_64.tgz
	tar
	wget https://github.com/OoliteProject/OoliteStarter/releases/download/v0.1.32/oolitestarter_0.1-32_amd64.deb
	tar -xvzf oolite-1.90.linux-x86_64.tgz
	./oolite-1.90.linux-x86_64.run
	sudo dpkg -i oolitestarter_0.1-32_amd64.deb

	;;
9)
	#browsh
	echo -e "${B}Downloading and installing ${R}Browsh${B} browser${N}"
	wget https://github.com/browsh-org/browsh/releases/download/v1.8.0/browsh_1.8.0_linux_amd64.deb
	sudo dpkg -i browsh_1.8.0_linux_amd64.deb
	;;


10)
	#nix package manager
	curl -L https://nixos.org/nix/install | sh
sudo echo " . /home/$USER/.nix-profile/etc/profile.d/nix.sh" >> .bashrc
source .bashrc

;;

esac
done

   #}}}


#}}}

##########################################################
#{{{###                                                    ###
##########################################################


#}}}
##########################################################
#{{{###                                                    ###
##########################################################

#}}}
##########################################################
#{{{###                                                    ###
##########################################################



#}}}
##########################################################
#{{{###                                                    ###
##########################################################

#}}}
fi
