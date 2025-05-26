#!/bin/bash

wl-present freeze

wtype $(grep -v '^#' ~/.local/share/key | fuzzel -w 50% \
	-b 002b36cc -t 586e75ff -M cb4b16ff -m 657b83ff -S 93a1a1ff \
	-s 073642cc -B 2 -r 0 -C 073642ff --input-color cb4b16ff \
	--font monospace:size=12 -I -D no -l 0 --cache=/dev/null --dmenu | cut -d' ' -f1)

wl-present unfreeze
