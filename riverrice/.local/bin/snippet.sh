wtype $(grep -v '^#' ~/.local/share/snippets | fuzzel -T footclient -w 90% -b 181825dd -t cdd6f4ff -m cba6f7ff \
	-s cdd6f4ff -B 0 -r 15 -C cdd6f4ff --font Hack --use-bold -I -D no \
	--filter-desktop $@ <&0 --cache=/dev/null --dmenu | cut -d' ' -f1)
