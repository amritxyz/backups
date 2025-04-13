#!/bin/bash
wtype $(grep -v '^#' ~/.local/share/snippets | fuzzel -T footclient -w 90% -b 282828cc -t ebdbb2ff -m fabd2fff \
	-s 3c3836cc -B 2 -r 0 -C ebdbb2ff --font Hack -I -D no \
	--filter-desktop $@ <&0 --cache=/dev/null --dmenu | cut -d' ' -f1)
