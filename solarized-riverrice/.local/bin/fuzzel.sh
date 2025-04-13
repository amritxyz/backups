#!/bin/bash
fuzzel -T footclient -w 64% -b 002b36cc -t 839496ff -m b58900ff \
	-s 073642cc -B 2 -r 0 -C 839496ff --font Hack -I -D no \
	--filter-desktop "$@" <&0 --cache=/dev/null
