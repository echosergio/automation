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

setxkbmap es

sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

info "Fixing graphics and power management by changing the GRUB configuration..."
sudo sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/GRUB_CMDLINE_LINUX_DEFAULT="nouveau.modeset=0 acpi_rev_override=1"/g' /etc/default/grub
sudo update-grub

info "Setting Windows as the default startup option..."
sudo sed -i -e 's/GRUB_DEFAULT=0/GRUB_DEFAULT=saved/g' /etc/default/grub
sudo grub-set-default 2
sudo update-grub

info "Making Linux use local time..."
timedatectl set-local-rtc 1 --adjust-system-clock
    
info "Setting up UFW Firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

sudo apt-get -y autoremove
sudo apt-get -y upgrade
