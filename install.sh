##!/bin/bash
#clear
#
#echo "batan ALL=(ALL:ALL) NOPASSWD:ALL"|sudo EDITOR='tee -a' visudo
#


##################################################################
####               CHECKING GOUPS                              ###
##################################################################


# User to modify (replace with your username or pass as argument)
USER="batan"

# List of groups to check and add
GROUPS=(
    lp
    dialout
    cdrom
    floppy
    sudo
    audio
    dip
    video
    plugdev
    users
    netdev
    lpadmin
    vboxsf
    scanner
    sambashare
)

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

echo "Group membership check and update complete for $USER."








##################################################################
####                   APT DEPENDENCIES                        ###
##################################################################

# List of dependencies to check
dependencies=( 'spice-webdavd' 'sweeper' 'tesseract-ocr' 'tkremind' 'tldr' 'tmux' 'trash-cli' 'ueberzug' 'vim' 'vulkan-tools' 'vulkan-validationlayers' 'xcape' 'xclip' 'xdo' 'zip' 'unzip' \
'pkg-config' 'libxcb-xfixes0-dev' 'libxcb-cursor-dev' 'libxcb-util-dev' 'libxkbcommon-dev' 'libxkbcommon-x11-dev' 'libxcb-keysyms1-dev' 'libxcb-xrm-dev' 'libev-dev' \
'libyajl-dev' 'asciidoc' 'xmlto' 'libpod-simple-perl' 'docbook-xml' 'libpcre3-dev' 'libstartup-notification0-dev' 'libpango1.0-dev' 'libcairo2-dev' \
'abook' 'alacritty' 'axel' 'bash' 'buku' 'ca-certificates' 'cargo' 'cava' 'cmus' \
'curl' 'ddgr' 'dialog' 'distrobox' 'docker' 'docker-compose' 'duf' 'dunst' 'dwm' 'falkon' \
'featherpad' 'feh' 'ffmpeg' 'flatpak' 'fonts-jetbrains-mono' 'fzf' 'git' 'gnome-boxes' \
'gparted' 'i3' 'intel-media-va-driver-non-free' 'intel-microcode' 'isync' 'kodi'  \
'libsox-fmt-all' 'live-build' 'live-clone' 'locate' 'lynx' 'lynx' 'man2html' \
'megatools' 'mesa-vulkan-drivers' 'minidlna' 'moc-ffmpeg-plugin' 'mpd' 'mutt-wizard' \
'nala' 'ncmpcpp' 'neomutt' 'neomutt' 'notmuch' 'nwipe' 'openssh-server' 'openssh-client' 'openssh-server' \
'optipng' 'pandoc' 'pass' 'pavucontrol' 'picom' 'pipx' 'podman' 'policykit-1-gnome' 'powerline' \
'pulseaudio' 'pwman3' 'python3-i3ipc' 'python3-pip' 'python3-powerline-taskwarrior'  \
'python3-pynvim' 'qutebrowser' 'ranger' 'rename' 'renameutils' 'ripgrep' 'rofi' \
'sox' 'spice-vdagent' 'sshfs' 'stterm' 'suckless-tools' 'sudo' 'surf' 'sway' \
'urlview' 'wget' 'xfce4-terminal' 'xterm' 'ufw' 'yad' 'silversearcher-ag' )







# Function to check if a package is installed
check_dependency() {
    dpkg -s "$1" >/dev/null 2>&1
}

# Collect missing packages
missing_packages=()
for dep in "${dependencies[@]}"; do
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


#################################################################
###                   GITHUB REPOSITORIES                     ###
###                                                           ###
###                                                           ###
###                                                           ###
###                                                           ###
#################################################################
###   DISPLAY   #################################################
echo -e "\033[47m\033[30m Recommended course of action,\033[0m"
echo -e "\033[34m1\033[33m) \033[34mCreate a GPG key with and for your default email"
echo -e "\033[34m2\033[33m) \033[34mCreate SSH key-pair"
echo -e "\033[34m3\033[33m) \033[34mConnect to remote machine and setup SSH-keys"
echo -e "\033[34mDownload and install following github repositores:"
echo -e "\033[36m------------------------------------------------------------\033[0m"
echo -e "\033[31mLc-cd 		  \033[34mCustomized Directory Naviation \033[0m"
echo -e "\033[31mHosts 		  \033[34mBlock 75k muddy internet domains via custom host file\033[0m"
echo -e "\033[31mNautilus Scripts \033[34mAdd custom scripts to your GUI file browser \033[0m"
echo -e "\033[31mNerd Fonts	  \033[34mInstall custom fonts \033[0m"
echo -e "\033[31mLC backgrounds	  \033[34mInstall custom backgrounds \033[0m"
###   get repositories   #######################################
git clone https://github.com/batann/.dot.git
git clone https://github.com/batann/lc-cd.git
git clone https://github.com/batann/hosts.git
git clone https://github.com/batann/script-server.git
git clone https://github.com/batann/vim.git
git clone https://github.com/batann/mutt-wizard.git
git clone https://github.com/batann/i3.git
git clone https://github.com/batann/grub.git
git clone https://github.com/vimwiki/vimwiki.git /home/batan/.config/nvim/pack/plugins/start/vimwiki
git clone https://github.com/farseer90718/vim-taskwarrior ~/.config/nvim/pack/plugins/start/vim-taskwarrior
git clone https://github.com/tools-life/taskwiki.git /home/batan/.config/nvim/pack/plugins/start/taskwiki --branch dev
git clone https://github.com/tpope/vim-surround.git /home/batan/.config/nvim/pack/plugins/start/surround-vim
#git clone https://github.com/batann/
#git clone https://github.com/batann/
#git clone https://github.com/batann/
#git clone https://github.com/batann/
#git clone https://github.com/batann/
#git clone https://github.com/batann/
#git clone https://github.com/batann/
#git clone https://github.com/batann/

git clone https://github.com/pasky/speedread.git
sudo cp speedread/speedread /usr/bin/lc-linux
git clone https://github.com/jahendrie/shalarm.git
cd shalarm
sudo make insall && cd


###   run install files   ######################################
sudo bash /home/batan/.dot/install.sh
sudo -u batan bash lc-cd/install.sh
sudo -u batan bash hosts/install.sh
sudo -u batan bash nautilus-scripts/install.sh
sudo -u batan bash mutt-wizard/install.sh
cd /home/batan/mutt-wizard
sudo make install
cd
sudo -u batan bash vim/install.sh
sudo -u batan bash i3/install.sh
sudo -u batan bash grub/install.first.sh
sudo -u batan bash grub/install.sh
sudo trash .dot lc-cd hosts nautilus-scripts mutt-wizard vim i3
#################################################################
###                        GPG                                ###
#################################################################

###   Check if GPG is installed   ########################
command -v gpg >/dev/null 2>&1 || { echo >&2 "GPG is not installed. Please install GPG and try again."; exit 1; }
###   Set key details   ##################################
full_name="fairdinkum batan"
email_address="fairdinkumbatan@gmail.com"
passphrase="Ba7an?12982"
app_password="ixeh bhbn dbrq pbyc"
###   Generate GPG key   #################################
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

clear
echo "GPG key generation completed. Please make sure to remember your passphrase."
read -n1 -p ' Press [any] to Continue ....' abc
pass init fairdinkumbatan@gmail.com
clear

#################################################################
###          SSH CONFIG, LOCAL and REMOTE                     ###
#################################################################

key_name="id_rsa"
key_location="$HOME/.ssh/$key_name"
ssh-keygen -t rsa -b 4096 -f "$key_location" -N ""

###   Function to configure SSH on a remote machine   ###########
configure_ssh() {
    # SSH configuration file path
    ssh_config="/etc/ssh/sshd_config"
    # Combine all SSH configuration changes into one command
    ssh -o "StrictHostKeyChecking=no" -o "PasswordAuthentication=no" "$1" "\
        sudo sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' $ssh_config && \
        sudo sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' $ssh_config && \
        sudo service ssh restart"
aa}


active_ips=()
local_ip=$(hostname -I | awk '{print $1}')

for i in $(seq 35 40); do
    current_ip="192.168.1.$i"
    if [ "$current_ip" != "$local_ip" ] && ping -s90 -i1 -c1 "$current_ip" &> /dev/null; then
        active_ips+=("$current_ip")
    fi
done

for ip in "${active_ips[@]}"; do
    ssh-copy-id -i ~/.ssh/id_rsa.pub batan@"$ip"
done
clear
read -n1 -p    '           Press [any] to Continue...'


#################################################################
###  ** MEGA SYNC **                                          ###
###  download and unpack :                                    ###
###  10 100 dot check backgrounds fonts                       ###
#################################################################
clear

###   check for megatools   ##########################################
if command -v megatools >/dev/null 2>&1; then
    echo "megatools is installed."
else
    echo "megatools is not installed."
fi
##   check for megatools RC   #######################################

if [[ ! -d /home/batan/.megarc ]]; then
	echo -e "\033[31mMegatools RC \033[33mis not installed.\033[0m"
else
	echo -e "\033[31mMegatools RC \033[33mis not installed.\033[0m"
fi

#megaget /Root/fonts.tar.gz
#megaget /Root/backgrounds.tar.gz
#megaget /Root/10.tar.gz
#megaget /Root/100.tar.gz
megaget /Root/dot.tar.gz
megaget /Root/check.tar.gz
sudo tar vfxz fonts.tar.gz --directory=/usr/share/fonts
sudo tar vfxz backgrounds.tar.gz --directory=/usr/share/backgrounds/
tar vfxz 10.tar.gz
tar vfxz 100.tar.gz
tar vfxz check.tar.gz
tar vfxz dot.tar.gz

sudo trash fonts.tar.gz
sudo trash backgrounds.tar.gz

#########################################################################
###   RUNNING DOT.SH AS PART OF THE MAIN SCRIPT                      ####
#########################################################################
clear
if [[ -d /home/batan/.cache/calendar.vim ]]; then
cp dot/credentials.vim /home/batan/.cache/calendar.vim
else
mkdir /home/batan/.cache/calendar.vim/
cp dot/credentials.vim /home/batan/.cache/calendar.vim
fi
clear
############################################################################

if [[ -f $HOME/.bashrc ]]; then
	mv $HOME/.bashrc $HOME/.bashrc.bak.$ddd.$(date +%H:%M)
	cp -r $HOME/dot/bashrc $HOME/.bashrc
else
	cp -r $HOME/dot/bashrc $HOME/.bashrc
fi
############################################################################
if [[ -f $HOME/.bashrc.aliases ]]; then
	mv $HOME/.bashrc.aliases $HOME/.bashrc.alaises.bak.$ddd.$(date +%H:%M)
	cp -r $HOME/dot/bashrc.aliases $HOME/.bashrc.aliases
else
	cp -r $HOME/dot/bashrc.aliases $HOME/.bashrc.aliases
fi
############################################################################

if [[ -f $HOME/.vimrc ]]; then
	mv $HOME/.vimrc $HOME/.vimrc.bak.$ddd.$(date +%H:%M)
	cp -r $HOME/dot/vimrc $HOME/.vimrc
else
	cp -r $HOME/dot/vimrc $HOME/.vimrc
fi
############################################################################

if [[ -f $HOME/.taskrc ]]; then
	mv $HOME/.taskrc $HOME/.taskrc.bak.$ddd.$(date +%H:%M)
	cp -r $HOME/dot/taskrc $HOME/.taskrc
else
	cp -r $HOME/dot/taskrc $HOME/.taskrc
fi
############################################################################

if [[ -f $HOME/.xboardrc ]]; then
	mv $HOME/.xboardrc $HOME/.xboardrc.bak.$ddd.$(date +%H:%M)
	cp -r $HOME/dot/xboardrc $HOME/.xboardrc
else
	cp -r $HOME/dot/xboardrc $HOME/.xboardrc
fi
############################################################################

if [[ -f $HOME/.tkremind ]]; then
	mv $HOME/.tkremind $HOME/.tkremind.bak.$ddd.$(date +%H:%M)
	cp -r $HOME/dot/tkremind $HOME/.tkremind
else
	cp -r $HOME/dot/tkremind $HOME/.tkremind
fi
############################################################################

if [[ -f $HOME/.xterm.conf ]]; then
	mv $HOME/.xterm.conf $HOME/.xterm.conf.bak.$ddd.$(date +%H:%M)
	cp -r $HOME/dot/xterm.conf $HOME/.xterm.conf
else
	cp -r $HOME/dot/xterm.conf $HOME/.xterm.conf
fi
############################################################################
if [[ -f $HOME/.Xresources ]]; then
	mv $HOME/.Xresources $HOME/.Xresources.bak.$ddd.$(date +%H:%M)
	cp -r $HOME/dot/Xresources $HOME/.Xresources
else
	cp -r $HOME/dot/Xresources $HOME/.Xresources
fi
############################################################################
if [[ -f $HOME/.bash_profile ]]; then
	mv $HOME/.bash_profile $HOME/.bash_profile.bak.$ddd.$(date +%H:%M)
	cp -r $HOME/dot/bash_profile $HOME/.bash_profile
else
	cp -r $HOME/dot/bash_profile $HOME/.bash_profile
fi
############################################################################
	if [[ -f $HOME/.tmux.config ]]; then
	mv $HOME/.tmux.config $HOME/.tmux.config.bak.$ddd.$(date +%H:%M)
	cp -r $HOME/dot/tmux.config $HOME/.tmux.config
else
	cp -r $HOME/dot/tmux.config $HOME/.tmux.config
fi
############################################################################
	if [[ -f $HOME/.Xdefault ]]; then
	mv $HOME/.Xdeafault $HOME/.Xdefault.bak.$ddd.$(date +%H:%M)
	cp -r $HOME/dot/Xdefault $HOME/.Xdefault
else
	cp -r $HOME/dot/Xdefault $HOME/.Xdefault
	fi
#############################################################################
if [[ -f .vim/pack/plugins/start/vimwiki/autoload/vimwiki/default.tpl ]]; then
	mv $HOME/.vim/pack/plugins/start/vimwiki/autoload/vimwiki/default.tpl $HOME/.vim/pack/plugins/start/vimwiki/autoload/vimwiki/default.tlp.$ddd.$(date +%H:%M)
	cp $HOME/dot/default.tlp $HOME/.vim/pack/plugins/start/vimwiki/autoload/vimwiki/default.tlp
fi
############################################################################
if [[ -f /etc/hosts ]]; then
sudo mv /etc/hosts /etc/hosts.original.$ddd.$(date +%H:%M)
	sudo cp -r $HOME/dot/hosts /etc/hosts
else
	sudo cp  $HOME/dot/hosts /etc/hosts
fi

#########################################################################
###   RUNNING BIN.SH AS PART OF THE MAIN SCRIPT                       ###
#########################################################################

sudo tar vfxz /home/batan/dot/bin.tar.gz --directory /usr/bin/
for i in $(tar list -f /home/batan/dot/bin.tar.gz);do sudo chmod +x /usr/bin/$i;done

#########################################################################
###   SETTING UP THE FIREWALL                                         ###
#########################################################################

for i in $(seq 35 40);
do
sudo ufw allow from 192.168.1.$i && sudo ufw allow to 192.168.1.$i
done
sudo ufw enable
curl -s 'https://liquorix.net/install-liquorix.sh' | sudo bash
sudo grub-mkconfig -o /boot/grub/grub.cfg


#########################################################################
###               INSTALL CUBIC DEBIAN AND DERIVATIVES                ###
#########################################################################

sudo apt update
sudo apt install --no-recommends dpkg

echo "deb https://ppa.launchpadcontent.net/cubic-wizard/release/ubuntu/ noble main" | sudo tee /etc/apt/sources.list.d/cubic-wizard-release.list
curl -S "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x081525e2b4f1283b" | sudo gpg --batch --yes --dearmor --output /etc/apt/trusted.gpg.d/cubic-wizard-ubuntu-release.gpg

sudo apt update
sudo apt install --no-install-recommends cubic


#########################################################################
###                                                                   ###
#########################################################################

