#!/bin/bash

# This script captures a screenshot using `grim` and saves it in a numbered sequence in ~/.local/ss.
# It allows the user to select a region using `slurp` and automatically increments the filename.

# Directory to save screenshots
SAVE_DIR=~/.local/ss

if [ ! -d "$SAVE_DIR" ]; then
    mkdir -p "$SAVE_DIR"
fi

# Find the highest number used in existing filenames
MAX_NUMBER=$(ls -1 $SAVE_DIR/*_screenshot.png 2>/dev/null | \
              awk -F'[_]' '{print $1}' | \
              awk -F/ '{print $NF}' | \
              sort -n | \
              tail -1)

# ls -1 ~/Pictures/*_screenshot.png | awk -F'[_]' '{print $1}' | awk -F/ '{print $NF}' | sort -n | tail -1

# Check if ls found any files
if [ -z "$MAX_NUMBER" ]; then
  # If no files were found, set MAX_NUMBER to 0
  MAX_NUMBER=0
fi

# Determine the next number
NEXT_NUMBER=$((MAX_NUMBER + 1))

# Create the screenshot with the new filename
FILENAME="$SAVE_DIR/${NEXT_NUMBER}_screenshot.png"

# Get the region to capture
REGION=$(slurp)

# Check if slurp produced any output
if [ -n "$REGION" ]; then
  grim -g "$REGION" "$FILENAME"
fi
