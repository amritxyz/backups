#!/bin/bash
#
# =============================================================================
# Copyright (C) 2024 amritxyz
# https://amritxyz.github.io
#
# River Compositor Setup Script (Wayland)
# This script installs all necessary components to run the River Compositor
# on Wayland, along with my personal rice and configurations.
# =============================================================================
#

# Enable strict mode: Exit on error and undefined variables
set -euo pipefail

# ANSI color codes
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[0;36m"
RESET="\033[0m"
BOLD="\033[1m"
CHECK="\xE2\x9C\x94"
CROSS="\xE2\x9D\x8C"
INFO="\xE2\x84\xB9"

# Logging function with color
log() {
	echo -e "${BLUE}[INFO]$(date +'%Y-%m-%d %H:%M:%S')${RESET} $1"
}

success() {
	echo -e "${GREEN}${CHECK} $1${RESET}"
}

warn() {
	echo -e "${YELLOW}${INFO} $1${RESET}"
}

fail() {
	echo -e "${RED}${CROSS} $1${RESET}"
}

ask() {
	echo -ne "${CYAN}$1 ${RESET}"
}

# Cleanup Home Directory
cleanup_home_dir() {
	ask "Cleanup: Would you like to clean up your home directory? [y/N] "
	read -r DLT
	if [[ "$DLT" == "y" || "$DLT" == "Y" ]]; then
		log "Cleaning up hidden files in \$HOME..."
		sudo rm -rf "$HOME"/.[!.]*
		success "Cleanup complete."
	else
		warn "Skipping cleanup."
	fi
}

# Disable WiFi Power Saver
disable_wifi_powersave() {
	ask "WiFi: Disable WiFi powersave? [Y/n] "
	read -r WIFI
	if [[ "$WIFI" != "n" && "$WIFI" != "N" ]]; then
		LOC="/etc/NetworkManager/conf.d/wifi-powersave.conf"
		log "Disabling WiFi powersave in $LOC..."
		echo -e "[connection]\nwifi.powersave = 2" | sudo tee "$LOC" > /dev/null
		sudo systemctl restart NetworkManager
		sleep 3
		success "WiFi powersave disabled."
	else
		warn "Skipping WiFi powersave configuration."
	fi
}

# Enable Multilib Packages
enable_multilib() {
	ask "Multilib: Enable Multilib packages? [Y/n] "
	read -r MULLIB
	if [[ "$MULLIB" != "n" && "$MULLIB" != "N" ]]; then
		log "Backing up /etc/pacman.conf and enabling Multilib..."
		sudo cp /etc/pacman.conf /etc/pacman.conf.backup
		mline=$(grep -n "\\[multilib\\]" /etc/pacman.conf | cut -d: -f1)
		rline=$((mline + 1))
		sudo sed -i "${mline}s|#\[multilib\]|\[multilib\]|g" /etc/pacman.conf
			sudo sed -i "${rline}s|#Include = /etc/pacman.d/mirrorlist|Include = /etc/pacman.d/mirrorlist|g" /etc/pacman.conf
			success "Multilib enabled. Please run ${YELLOW}sudo pacman -Syu${RESET} to update."
	else
		warn "Skipping Multilib configuration."
	fi
}

# Read packages from external file and install them
install_packages() {
	# Get the directory where the script is located
	SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
	PACKAGES_FILE="$SCRIPT_DIR/packages"

	ask "Packages: Install required packages from 'packages' file? [Y/n] "
	read -r INST

	if [[ "$INST" != "n" && "$INST" != "N" ]]; then
		if [[ ! -f "$PACKAGES_FILE" ]]; then
			fail "Packages file not found at: $PACKAGES_FILE"
			exit 1
		fi

		# Read the file, ignoring comments and empty lines
		mapfile -t PACKAGES < <(grep -vE '^\s*#|^\s*$' "$PACKAGES_FILE")

		log "Installing packages..."
		sudo pacman -Sy --needed "${PACKAGES[@]}"
		success "Packages installed successfully."
	else
		warn "Skipping package installation."
	fi
}

# Create Directories
create_directories() {
	log "Creating directories..."
	mkdir -p ~/.local/{share,bin,git-repos,hugo-dir,dox,vids,music,audio} ~/.config
	success "Directories created."
}

# Clone Repositories
clone_repos() {
	log "Cloning repositories..."
	# git clone --depth=1 https://github.com/amritxyz/riverrice.git ~/riverrice
	git clone --depth=1 https://github.com/amritxyz/dev.git ~/.local/dev
	git clone --depth=1 https://github.com/amritxyz/kickstart-nvim.git ~/.config/nvim
	git clone --depth=1 https://github.com/amritxyz/river-wall.git ~/.local/share/river-wall
	success "Repositories cloned successfully."
}

# Manage Dotfiles
manage_dotfiles() {
	log "Setting up dotfiles from riverrice..."
	cp -r ~/riverrice/.local/share/* ~/.local/share
	cp -r ~/riverrice/.local/bin/* ~/.local/bin
	cp -r ~/riverrice/.config/* ~/.config
	cp ~/riverrice/.bashrc ~/.bashrc
	cp ~/riverrice/.bash_profile ~/.bash_profile
	cp ~/riverrice/.inputrc ~/.inputrc
	mv ~/riverrice ~/.local/git-repos/
	success "Dotfiles copied and applied."
}

# Start Bluetooth Service
start_bluetooth() {
	log "Enabling and starting Bluetooth service..."

	if sudo systemctl enable bluetooth.service && sudo systemctl start bluetooth.service; then
		success "Bluetooth service enabled and started."
	else
		fail "Failed to start Bluetooth service. Please check the service status manually."
		warn "Run: ${YELLOW}sudo systemctl status bluetooth.service${RESET} to investigate."
	fi
}

# Main Function
main() {
	echo -e "\n${BOLD}${GREEN}=== RiverWM / Riverice Setup Script ===${RESET}\n"
	cleanup_home_dir
	disable_wifi_powersave
	enable_multilib
	install_packages
	create_directories
	clone_repos
	manage_dotfiles
	start_bluetooth

	sudo mkdir -p /opt/void
	sudo chown "$USER:$USER" /opt/void/
	echo
	success "Setup complete! RiverWM / Riverice installed successfully."
	echo -e "${YELLOW}You may want to reboot or start a Wayland session now.${RESET}"
}

# Run main
main
