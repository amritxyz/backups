#!/bin/bash
wtype $(grep -v '^#' ~/.local/share/key | fuzzel -T footclient -w 50% \
	-b 282828cc -t ebdbb2ff -m fabd2fff -s 3c3836cc \
	-B 2 -r 0 -C ebdbb2ff --font Hack -I -D no \
	-l 3 --filter-desktop "$@" <&0 --cache=/dev/null --dmenu | cut -d' ' -f1)
