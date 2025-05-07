#!/bin/bash
fuzzel -T footclient -w 64% \
	-b 002b36cc -t 586e75ff -M cb4b16ff -m 657b83ff -S 93a1a1ff \
	-s 073642cc -B 2 -r 0 -C 073642ff --input-color cb4b16ff \
	--font monospace:size=12 -I -D no --cache=/dev/null --filter-desktop "$@" <&0
