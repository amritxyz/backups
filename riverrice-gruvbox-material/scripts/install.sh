#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

echo
log "Syncing Mirrors..."
sudo pacman -Syy

echo
log "Starting Modular Installation..."

for group in base fonts daemons terminal cli media wm apps dev bloat tex; do
	bash "$SCRIPT_DIR/install-group.sh" "$group"
done

echo
success "All package groups installed!"

echo
bash "$SCRIPT_DIR/cleanup.sh"

echo
bash "$SCRIPT_DIR/tmp.sh"
bash "$SCRIPT_DIR/setup-dotfiles.sh"
bash "$SCRIPT_DIR/services.sh"
bash "$SCRIPT_DIR/clone-repos.sh"
