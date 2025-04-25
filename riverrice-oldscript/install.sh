#!/bin/sh

# Cleanup first
read -rep ':: Would you like to cleanup Home Dir? [y/N] ' DLT
if [[ $DLT == "N" || $DLT == "n" || -z $DLT ]]; then
	echo "Exiting..."
	break
else
	echo "Cleaning..."
	sudo rm -rf $HOME/.[!.]*
fi

# Disable Wifi-Power Saver
read -rep ':: Would you like to disable wifi powersave? [Y/n] ' WIFI
if [[ $WIFI == "Y" || $WIFI == "y" || -z $WIFI ]]; then
	LOC="/etc/NetworkManager/conf.d/wifi-powersave.conf"
	echo -e "The following has been added to $LOC.\n"
	echo -e "[connection]\nwifi.powersave = 2" | sudo tee -a $LOC
	echo -e "\n"
	echo -e "Restarting NetworkManager service...\n"
	sudo systemctl restart NetworkManager
	sleep 3
fi

# Enable Multi-Lib Packages
read -rep ':: Would you like to enable "Multilib Packages" [Y/n] ' MULLIB
if [[ $MULLIB == "Y" || $MULLIB == "y" || -z $MULLIB ]]; then
	sudo cp /etc/pacman.conf /etc/pacman.conf.backup
	mline=$(grep -n "\\[multilib\\]" /etc/pacman.conf | cut -d: -f1)
	rline=$(($mline + 1))
	sudo sed -i ''$mline's|#\[multilib\]|\[multilib\]|g' /etc/pacman.conf
	sudo sed -i ''$rline's|#Include = /etc/pacman.d/mirrorlist|Include = /etc/pacman.d/mirrorlist|g' /etc/pacman.conf
fi


read -rep ':: Would you like to install the packages? [Y/n] ' INST
if [[ $INST == "Y" || $INST == "y" || -z $INST ]]; then
	sudo pacman -Sy --needed base-devel && \
		sudo pacman -S --needed tesseract-data-nep river brightnessctl foot wlr-randr \
		waybar tmux mpv neovim pulsemixer bleachbit fastfetch unzip ripgrep imv lf hugo wl-mirror \
		newsboat waylock wtype wl-clipboard fuzzel htop grim slurp man-db zathura zathura-pdf-poppler \
		vulkan-intel xdg-desktop-portal-wlr xdg-desktop-portal-gtk adwaita-icon-theme swaybg \
		bluez bluez-utils gimp imagemagick wget deluge-gtk fzf curl cmatrix gnu-netcat mako libnotify \
		texlive-latex texlive-latexextra texlive-pictures texlive-xetex texlive-latexrecommended \
		gnu-free-fonts ttf-hack ttf-hack-nerd noto-fonts-emoji git-lfs wf-recorder kanshi \
		rust go jdk-openjdk maven nodejs npm php
fi

# Mkdir
mkdir -p ~/.local/share ~/.config ~/.local/bin ~/.local/git-repos ~/.local/hugo-dir ~/.local/dox ~/.local/vids ~/.local/music ~/.local/audio

# Post Installation
git clone --depth=1 https://github.com/amritxyz/dev.git/ ~/.local/dev
git clone --depth=1 https://github.com/amritxyz/kickstart-nvim.git ~/.config/nvim
git clone --depth=1 https://github.com/amritxyz/river-wall.git ~/.local/share/river-wall

# Managing Dotfiles
cp -r ~/riverrice/.local/share/* ~/.local/share
cp -r ~/riverrice/.local/bin/* ~/.local/bin
cp -r ~/riverrice/.config/* ~/.config
cp ~/riverrice/.bashrc ~/.bashrc
cp ~/riverrice/.bash_profile ~/.bash_profile
cp ~/riverrice/.inputrc ~/.inputrc

# Cleaning Home Dir
mv ~/riverrice ~/.local/git-repos/

# Start the bluetooth service
sudo systemctl enable bluetooth.service

# Just a empty directory for working stuffs
sudo mkdir -p /opt/void
sudo chown $USER:$USER /opt/void/

echo
echo "Successfully Installed RiverWm / Riverice."
echo
