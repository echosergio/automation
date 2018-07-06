#!/usr/bin/env bash

DISTRIB_RELEASE="18.04"

warn() {
	echo "WARNING: $@" >&1
}

info() {
	echo "$@" >&1
}

error() {
	echo "ERROR: $@" >&2
}

if [ $(awk '/DISTRIB_RELEASE=/' /etc/*-release | sed 's/DISTRIB_RELEASE=//') != ${DISTRIB_RELEASE} ]; then
	error "Ubuntu distribution release do not match"
	exit 
fi

sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

info "Installing Ubuntu software..."
sudo apt-get install -y git gitk htop vim filezilla gparted unrar meld keepassx pdfmod vlc

info "Installing Snap software..."
sudo snap install skype --classic
sudo snap install spotify 
sudo snap install slack 
sudo snap install corebird 
sudo snap install gimp && snap connect gimp:removable-media :removable-media
sudo snap install intellij-idea-community --classic --edge

info "Installing Java Default JRE/JDK..."
sudo apt-get install -y default-jre
sudo apt-get install -y default-jdk

info "Installing Docker..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) test"
sudo apt update
sudo apt install -y docker-ce
sudo groupadd docker
sudo usermod -aG docker $USER

info "Installing Docker Compose..."
sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

info "Installing Node.js using NVM..."
sudo apt-get install -y build-essential libssl-dev
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
command -v nvm
nvm install 8.11.3

info "Installing Cisco VPN..."
sudo apt-get install -y vpnc network-manager-vpnc network-manager-vpnc-gnome network-manager-openconnect

# Cisco AnyConnect Secure Mobility Client v4.x
# https://software.cisco.com/download/home/286281283/type/282364313/release/4.5.05030?i=!pp
# sudo apt-get install -y libpangox-1.0-0 lib32z1 lib32ncurses5
# tar -xzvf anyconnect-linux64-4.5.05030-predeploy-k9.tar.gz
# cd anyconnect-4.5.05030/vpn/
# sudo ./vpn_install.sh

info "Installing Google Chrome..."
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb --output-document=google-chrome-stable_current_amd64.deb
sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb
sudo apt-get -f install -y

info "Installing Visual Studio Code..."
wget https://go.microsoft.com/fwlink/?LinkID=760868 --output-document=code_amd64.deb
sudo dpkg -i code_amd64.deb

info "Installing Postman..."
wget https://dl.pstmn.io/download/latest/linux64 -O postman.tar.gz
sudo tar -xzf postman.tar.gz -C /opt
sudo ln -s /opt/Postman/Postman /usr/bin/postman
cat > ~/.local/share/applications/postman.desktop <<EOL
[Desktop Entry]
Encoding=UTF-8
Name=Postman
Exec=postman
Icon=/opt/Postman/app/resources/app/assets/icon.png
Terminal=false
Type=Application
Categories=Development;
EOL

info "Customizing Gnome settings..."
sudo apt-get install -y gnome-tweak-tool
# GSettings is a GLib implementation of DConf, which stores its data in a binary database. 
# The GSettings command line tool is simply a tool to access or modify settings via the GSettings API.
# Monitor DConf for changes: dconf watch /
gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
gsettings set org.gnome.desktop.background show-desktop-icons false
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 32
gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false
profile=$(gsettings get org.gnome.Terminal.ProfilesList default)
profile=${profile:1:-1} # remove leading and trailing single quotes
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" default-size-columns 132
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" default-size-rows 43
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" foreground-color 'rgb(237,237,237)'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" background-color 'rgb(0,0,0)'
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" use-theme-colors false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" use-theme-transparency false
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" use-transparent-background true
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" background-transparency-percent 15
gsettings set "org.gnome.Terminal.Legacy.Profile:/org/gnome/terminal/legacy/profiles:/:$profile/" cursor-shape 'underline'
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ next-tab '<Primary>Left'
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ prev-tab '<Primary>Right'

info "Installing VMware Workstation dependencies..."
sudo apt-get -y install gcc make linux-headers-$(uname -r) dkms

info "Installing Oh My Zsh..."
sudo apt-get install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
chsh -s $(which zsh) # If you use sudo it will change the shell not for your working user but for root

# info "Installing LaTeX..."
# sudo apt-get install -y texlive-full
# sudo apt-get install -y texstudio

# info "Installing Git Aware Terminal..."
# npm install -g git-aware-terminal
# touch "$HOME/.bash_profile"
# gat install
# cat "$HOME/.bash_profile" >> "$HOME/.bashrc"
# rm "$HOME/.bash_profile"

sudo apt-get -y autoremove
sudo apt-get -y upgrade