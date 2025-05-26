#!/bin/bash

# Quick script to connect or disconnect Bluetooth devices on Unix systems.
# Shows a list of paired devices using bluetoothctl, lets you pick one with fuzzel,
# then connects if it's disconnected or disconnects if it's already connected.
# Uses notify-send to show status messages.

get_device_list() {
	bluetoothctl devices | awk -F ' ' '{print $3 " " $2}'
}

# Display devices using fuzzel
device_list=$(get_device_list)
selected_device=$(echo "$device_list" | fuzzel -w 30% \
	-b 002b36cc -t 586e75ff -M cb4b16ff -m 657b83ff -S 93a1a1ff \
	-s 073642cc -B 2 -r 0 -C 073642ff --input-color cb4b16ff \
	--font monospace:size=12 -I -D no --cache=/dev/null --dmenu --lines 2 | awk '{print $1}')

# Exit if nothing picked
if [ -z "$selected_device" ]; then
	notify-send "No device selected."
	exit 1
fi

# Extract MAC for the selected device
MAC=$(echo "$device_list" | grep "$selected_device" | awk '{print $2}')

# Exit if MAC not found
if [ -z "$MAC" ]; then
	notify-send "$selected_device..." "Failed to find MAC address."
	exit 1
fi

# Check current connection state
connect=$(bluetoothctl info "$MAC" | grep Connected: | awk '{print $2}')

# Decide whether to connect or disconnect
if [ "$connect" = "no" ]; then
    action="connect"
elif [ "$connect" = "yes" ]; then
    action="disconnect"
else
    notify-send "$selected_device" "Unknown status"
    exit 1
fi

# Do the action
notify-send "$selected_device" "Attempting to $action..."
if bluetoothctl "$action" "$MAC"; then
    notify-send "$selected_device" "Successfully ${action}ed."
else
    notify-send "$selected_device" "Failed to $action."
fi
