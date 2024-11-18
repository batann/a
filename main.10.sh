#!/bin/bash
# vim:fileencoding=utf-8:foldmethod=marker


#{{{### TEMPORARY List of random Packages
#tmux
git
dialog
yad
vim
#antix-snapshot-files

#
#
#
#
#}}}
#{{{### Set Variables

#}}}
#{{{### Set Dependencies

DEPS_FLUX="fluxbox idesk mx-fluxbox gkrellm mxfb-docs   mx-fluxbox-data mxfb-accessories wmalauncher  lxappearance  rofi-calc custom-toolbox roxterm feh"

DEPS_BOXES="gnome-boxes qemu-system-x86 libvirt-daemon-driver-lxc libvirt-daemon-driver-vbox libvirt-daemon-driver-xen netcat-openbsd tracker-miner-fs qemu-system-gui qemu-utils ovmf ibverbs-providers"

DEPS_LAMP="apache2 apache2-utils curl mariadb-server mariadb-client php8.2 libapache2-mod-php8.2 php8.2-mysql php-common php8.2-cli php8.2-common php8.2-opcache php8.2-xml php8.2-yaml php8.2-readline"

DEPS_CODIUM="apt-transport-https codium"
#https://paulcarroty.gitlab.io/vscodium-deb-rpm-repo/debs vscodium/main amd64 codium amd64 1.95.2.24313

DEPS_NVIM="wget curl git build-essential libtool libtool-bin autoconf cmake g++ pkg-config unzip ninja-build gettext libncurses5-dev libgnome2-dev libgnomecanvas2-dev libx11-dev libxt-dev python3-dev ruby-dev lua5.1.0-dev liblua5.1-0-dev python3-pynvim"

DEPS_I3="i3 lightdm surf stterm lightdm-gtk-greeter xorg rofi feh compton sddm picom thunar dunst suckless-tools surf x11-utils x11-xserver-utils "

DEPS_TREES="clang libclang-dev cmake make nodejs python3-setuptools python3-pynvim"

DEPS_DOCKER="docker.io"



#}}}
#{{{### Check for OS and the init system

#}}}
#{{{>>> Setup GPG-key
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
#}}}
#{{{>>> Setup SSH-keys

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
#{{{>>> Setup Firewall

sudo dpkg -s ufw >/dev/null
if [[ $? -eq 0 ]]; then
	echo "ufw is already installed."
else
sudo apt install -y ufw
fi
for i in $(seq 35 40);
do
	sudo ufw allow from 192.168.1.$i && sudo ufw allow to 192.168.1.$i
done
sudo ufw enable


#}}}
#{{{### Setup Dot and Config files

#}}}
#{{{### Setup Bin files

#}}}
#{{{### Setup a Desktop Environment I3 or Xfce

#}}}

#{{{### Setup Distrobox

#}}}



#{{{>>> Install Minidlana
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
#{{{>>> Install Samba

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
#{{{### Install LAMP stack

# Variables
DB_NAME="nextcloud"
DB_USER="batan"
DB_PASSWORD="Ba7an?12982"
NEXTCLOUD_URL="https://download.nextcloud.com/server/releases/latest.zip"
NEXTCLOUD_DIR="/var/www/html/nextcloud"
ADMIN_USER="batan"
ADMIN_PASSWORD="Ba7an?12982"
DOMAIN="localhost"

# Update and Install Dependencies
sudo apt update && sudo apt upgrade -y
sudo apt install apache2 mariadb-server libapache2-mod-php8.2 -y
sudo apt install php8.2 php8.2-gd php8.2-mysql php8.2-curl php8.2-xml php8.2-mbstring php8.2-zip php8.2-intl php8.2-bcmath php8.2-gmp php-imagick unzip wget -y

# Enable Apache Modules
sudo a2enmod rewrite headers env dir mime
sudo systemctl restart apache2

# Configure MariaDB
sudo systemctl start mariadb
sudo mysql_secure_installation <<EOF

Y
$DB_PASSWORD
$DB_PASSWORD
Y
Y
Y
Y
EOF

# Create Nextcloud Database and User
sudo mysql -uroot -p$DB_PASSWORD <<EOF
CREATE DATABASE $DB_NAME;
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'localhost';
FLUSH PRIVILEGES;
EXIT;
EOF

# Download and Install Nextcloud
cd /tmp
wget $NEXTCLOUD_URL -O nextcloud.zip
unzip nextcloud.zip
sudo mv nextcloud $NEXTCLOUD_DIR
sudo chown -R www-data:www-data $NEXTCLOUD_DIR
sudo chmod -R 755 $NEXTCLOUD_DIR

# Apache Configuration for Nextcloud
sudo bash -c "cat >/etc/apache2/sites-available/nextcloud.conf" <<EOF
<VirtualHost *:80>
    ServerAdmin admin@$DOMAIN
    DocumentRoot $NEXTCLOUD_DIR
    ServerName $DOMAIN

    <Directory $NEXTCLOUD_DIR>
        Options +FollowSymlinks
        AllowOverride All

        <IfModule mod_dav.c>
            Dav off
        </IfModule>

        SetEnv HOME $NEXTCLOUD_DIR
        SetEnv HTTP_HOME $NEXTCLOUD_DIR
    </Directory>

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

sudo a2ensite nextcloud.conf
sudo systemctl reload apache2

# Set Permissions
sudo chown -R www-data:www-data $NEXTCLOUD_DIR

# Install Nextcloud via Command Line
sudo -u www-data php $NEXTCLOUD_DIR/occ maintenance:install \
    --database "mysql" --database-name "$DB_NAME" \
    --database-user "$DB_USER" --database-pass "$DB_PASSWORD" \
    --admin-user "$ADMIN_USER" --admin-pass "$ADMIN_PASSWORD" \
    --data-dir "$NEXTCLOUD_DIR/data"

# Set local IP to trusted domain
LOCAL_IP=$(hostname -I | awk '{print $1}')
sudo -u www-data php $NEXTCLOUD_DIR/occ config:system:set trusted_domains 1 --value=$LOCAL_IP

# Restart Apache
sudo systemctl restart apache2

echo "Nextcloud installation complete. Access it via http://$LOCAL_IP"


#}}}
#{{{### Pipx packages

#}}}
#{{{### Install Librewolf

#}}}
#{{{### Cubic

#}}}
#{{{### Ungoogled Chromium

#}}}


#{{{### Install Neovim 0.10+ Version, TreeSitter and LSPs

#}}}

#{{{>>>   Install neovim with codium autocompleation

# Install neovim with codium autocompleation
clear
echo -e "\033[44m\033[30mInstalling neovim with codium autocompleation\033[0m"
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
sudo tar -C /opt -xzf nvim-linux64.tar.gz
sudo rm -rf /opt/nvim
git clone https://github.com/Exafunction/codeium.vim ~/.config/nvim/pack/Exafunction/start/codeium.vim

# Create init.vim file

cat << 'EOL' > /home/batan/.config/nvim/init.vim.codium
"# Codium Config
#disable default keybindings
vim.g.codeium_disable_bindings = 1
#disable codium by default
vim.g.codeium_enabled = false
#show codium in status line
vim.api.nvim_call_function("codeium#GetStatusString", {})
EOL

# Add init.vim
echo "source /home/batan/.config/nvim/init.vim.codium" >> /home/batan/.config/nvim/init.vim
sudo rm -rf nvim-linux64.tar.gz
echo -e "\033[44m\033[30mInstalling neovim with codium autocompleation done\033[0m"

# Install nvim-plug
echo -e "\033[44m\033[30mInstalling nvim-plug\033[0m"
curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Install nvim-cmp
echo -e "\033[44m\033[30mInstalling nvim-cmp\033[0m"
git clone https://github.com/hrsh7th/nvim-cmp ~/.config/nvim/pack/hrsh7th/start/nvim-cmp

# Install nvim-lspconfig
echo -e "\033[44m\033[30mInstalling nvim-lspconfig\033[0m"
git clone https://github.com/neovim/nvim-lspconfig ~/.config/nvim/pack/nvim-lspconfig/start/nvim-lspconfig

# Install nvim-treesitter
echo -e "\033[44m\033[30mInstalling nvim-treesitter\033[0m"
git clone https://github.com/nvim-treesitter/nvim-treesitter ~/.config/nvim/pack/nvim-treesitter/start/nvim-treesitter

# Install nvim-ts-autotag
echo -e "\033[44m\033[30mInstalling nvim-ts-autotag\033[0m"
git clone https://github.com/windwp/nvim-ts-autotag ~/.config/nvim/pack/nvim-ts-autotag/start/nvim-ts-autotag

# Install nvim-ts-context-commentstring
echo -e "\033[44m\033[30mInstalling nvim-ts-context-commentstring\033[0m"
git clone https://github.com/JoosepAlviste/nvim-ts-context-commentstring ~/.config/nvim/pack/nvim-ts-context-commentstring/start/nvim-ts-context-commentstring

# Install nvim-autopairs
echo -e "\033[44m\033[30mInstalling nvim-autopairs\033[0m"
git clone https://github.com/windwp/nvim-autopairs ~/.config/nvim/pack/nvim-autopairs/start/nvim-autopairs

# Install nvim-ts-rainbow
echo -e "\033[44m\033[30mInstalling nvim-ts-rainbow\033[0m"
git clone https://github.com/p00f/nvim-ts-rainbow ~/.config/nvim/pack/nvim-ts-rainbow/start/nvim-ts-rainbow

# Install nvim-ts-autotag
echo -e "\033[44m\033[30mInstalling nvim-ts-autotag\033[0m"
git clone https://github.com/windwp/nvim-ts-autotag ~/.config/nvim/pack/nvim-ts-autotag/start/nvim-ts-autotag

# Install nvim-lsp-ts-utils
echo -e "\033[44m\033[30mInstalling nvim-lsp-ts-utils\033[0m"
git clone https://github.com/jose-elias-alvarez/nvim-lsp-ts-utils ~/.config/nvim/pack/nvim-lsp-ts-utils/start/nvim-lsp-ts-utils

#}}}
#{{{>>>   Install docker and funkwhale
# Function to display error and exit
error_exit() {
  echo "Error: $1" >&2
  exit 1
}

# Update the package list and install prerequisites
echo "Updating package list and installing prerequisites..."
sudo apt update || error_exit "Failed to update package list"
sudo apt install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release || error_exit "Failed to install prerequisites"

# Add Docker's official GPG key
echo "Adding Docker's official GPG key..."
sudo mkdir -p /etc/apt/keyrings || error_exit "Failed to create keyring directory"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg || error_exit "Failed to add Docker's GPG key"

# Set up the Docker repository
echo "Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null || error_exit "Failed to set up Docker repository"

# Update package list and install Docker
echo "Installing Docker..."
sudo apt update || error_exit "Failed to update package list"
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin || error_exit "Failed to install Docker"

# Verify Docker installation
echo "Verifying Docker installation..."
docker --version || error_exit "Docker installation failed"

# Prompt for Funkwhale configuration
read -e -p "Enter the Funkwhale hostname (e.g., yourdomain.funkwhale): " -i 'funkwhale' FUNKWHALE_HOSTNAME
read -e -p "Enter the full path for Funkwhale data directory (e.g., /path/to/data): " -i '/media/batan/100/Music/data' DATA_DIR
read -e -p "Enter the full path for Funkwhale music directory (e.g., /path/to/music): " -i '/media/batan/100/Music/' MUSIC_DIR

if [[ ! -d "$DATA_DIR" ]]; then
	mkdir -p "$DATA_DIR"
fi


# Check if directories exist
[ ! -d "$DATA_DIR" ] && error_exit "Data directory does not exist: $DATA_DIR"
[ ! -d "$MUSIC_DIR" ] && error_exit "Music directory does not exist: $MUSIC_DIR"

# Run the Funkwhale Docker container
echo "Running Funkwhale container..."
docker run \
    --name=funkwhale \
    -e FUNKWHALE_HOSTNAME="$FUNKWHALE_HOSTNAME" \
    -e NESTED_PROXY=0 \
    -v "$DATA_DIR:/data" \
    -v "$MUSIC_DIR:/music:ro" \
    -p 3030:80 \
    thetarkus/funkwhale || error_exit "Failed to start Funkwhale container"

echo "Funkwhale is now running. Access it at http://localhost:3030 or http://$FUNKWHALE_HOSTNAME"
#}}}

