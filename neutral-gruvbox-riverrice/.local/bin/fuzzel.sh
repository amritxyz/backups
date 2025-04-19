#!/bin/bash
fuzzel -T footclient -w 64% -b 282828cc -t 928374ff -m d79921ff \
	-s 3c3836cc -B 2 -r 0 -C 928374ff --font Hack -I -D no \
	--filter-desktop "$@" <&0 --cache=/dev/null
