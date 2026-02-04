#!/usr/bin/env bash
#
# claude-env uninstaller
#
# Usage:
#   ./uninstall.sh
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Configuration
INSTALL_DIR="${HOME}/.local/bin"
REPO_DIR="${HOME}/.local/share/claude-env"

log_info() {
    echo -e "${GREEN}[+]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[!]${NC} $1"
}

log_error() {
    echo -e "${RED}[x]${NC} $1" >&2
}

main() {
    echo ""
    echo "=========================================="
    echo "       claude-env uninstaller"
    echo "=========================================="
    echo ""

    local removed=false

    # Remove symlink
    if [ -L "$INSTALL_DIR/claude-env" ] || [ -f "$INSTALL_DIR/claude-env" ]; then
        rm -f "$INSTALL_DIR/claude-env"
        log_info "Removed: $INSTALL_DIR/claude-env"
        removed=true
    fi

    # Remove cloned repository (only if installed via remote)
    if [ -d "$REPO_DIR" ]; then
        read -p "Remove cloned repository at $REPO_DIR? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm -rf "$REPO_DIR"
            log_info "Removed: $REPO_DIR"
        else
            log_warn "Kept repository at $REPO_DIR"
        fi
        removed=true
    fi

    if [ "$removed" = true ]; then
        echo ""
        log_info "Uninstall complete!"
    else
        log_warn "Nothing to uninstall"
    fi

    echo ""
    echo "Note: Your .env files were not removed."
    echo ""
}

main "$@"
