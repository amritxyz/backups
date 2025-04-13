#!/bin/bash
fuzzel -T footclient -w 64% -b 282828cc -t ebdbb2ff -m fabd2fff \
	-s 3c3836cc -B 2 -r 0 -C ebdbb2ff --font Hack -I -D no \
	--filter-desktop $@ <&0 --cache=/dev/null
