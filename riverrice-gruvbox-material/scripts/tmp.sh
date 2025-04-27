#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

log "Creating tmp env in /opt dir..."

sudo mkdir /opt/void/
sudo chown $USER:$USER /opt/void/

success "Successfully Created tmp env..."
