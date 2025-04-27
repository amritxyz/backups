#!/bin/sh

IMG="$HOME/.local/share/river-wall/2.png"

if [ ! -f "$IMG" ]; then
    exit 1
fi

if pgrep -x swaybg > /dev/null; then
    pkill -SIGKILL swaybg && swaybg -i "$IMG" &
else
    swaybg -i "$IMG" &
fi
