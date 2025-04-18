#!/bin/bash
wtype $(grep -v '^#' ~/.local/share/snippets | fuzzel -w 90% \
	-b 002b36cc -t 839496ff -m b58900ff \
	-s 073642cc -B 2 -r 0 -C 839496ff --font Hack -I -D no \
	--cache=/dev/null --dmenu | cut -d' ' -f1)
