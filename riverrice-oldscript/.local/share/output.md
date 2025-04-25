# Right Monitor
profile {
	output HDMI-A-1 enable position 1366,0
	output HDMI-A-1 position 1366,0 mode 3840x2160
}

# Helpful
profile {
	output HDMI-A-1 enable position 0,0 transform 90
	output DVI-D-1 enable position 1080,420
	output DVI-D-1 enable position 1366,0
}

# FHD Displays
profile {
	output eDP-1 position 0,0 mode 1920x1080
	output HDMI-A-1 position 1920,0 mode 1920x1080
	output HDMI-A-1 position 1920,0 mode 3840x2160
}

# Small Hack
wf-recorder -o eDP-1 - | mpv -
 
# Using a Graphical Tool for Mirroring #
sudo pacman -S wayvnc
