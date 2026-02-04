#!/usr/bin/env bash
#
# claude-env installer
#
# Remote install:
#   curl -fsSL https://raw.githubusercontent.com/jordanburke/claude-env/main/install.sh | bash
#
# Local install:
#   git clone https://github.com/jordanburke/claude-env.git
#   cd claude-env && ./install.sh
#

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Configuration
REPO_URL="https://github.com/jordanburke/claude-env.git"
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

log_step() {
    echo -e "${BLUE}[*]${NC} $1"
}

check_git() {
    if ! command -v git &> /dev/null; then
        log_error "git is required but not installed"
        echo ""
        echo "Install with:"
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo "  xcode-select --install"
        else
            echo "  sudo apt install git"
        fi
        exit 1
    fi
}

check_dependencies() {
    if ! command -v claude &> /dev/null; then
        log_warn "Claude Code is not installed"
        echo ""
        echo "Install with:"
        echo "  npm install -g @anthropic-ai/claude-code"
        echo ""
        read -p "Continue installation anyway? [y/N] " -n 1 -r < /dev/tty
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
}

clone_or_update_repo() {
    log_step "Setting up claude-env repository"

    if [ -d "$REPO_DIR/.git" ]; then
        log_info "Repository exists, pulling latest changes"
        git -C "$REPO_DIR" pull --quiet origin main || true
    else
        log_info "Cloning repository to $REPO_DIR"
        mkdir -p "$(dirname "$REPO_DIR")"
        git clone --quiet "$REPO_URL" "$REPO_DIR"
    fi
}

detect_install_source() {
    # Check if we're running from a local clone or remotely
    local script_dir=""

    # If BASH_SOURCE is empty or stdin, we're being piped
    if [ -z "${BASH_SOURCE[0]:-}" ] || [ "${BASH_SOURCE[0]}" = "bash" ]; then
        return 1  # Remote install
    fi

    script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"

    # Check if we're in a git repo with the expected structure
    if [ -f "$script_dir/bin/claude-env" ] && [ -d "$script_dir/.git" ]; then
        echo "$script_dir"
        return 0  # Local install
    fi

    return 1  # Remote install
}

install_script() {
    local source_dir="$1"

    log_step "Installing claude-env to $INSTALL_DIR"

    mkdir -p "$INSTALL_DIR"

    # Remove existing installation
    if [ -L "$INSTALL_DIR/claude-env" ] || [ -f "$INSTALL_DIR/claude-env" ]; then
        log_warn "Removing existing installation"
        rm -f "$INSTALL_DIR/claude-env"
    fi

    # Create symlink to allow updates via git pull
    ln -s "$source_dir/bin/claude-env" "$INSTALL_DIR/claude-env"
    log_info "Installed claude-env (symlinked to $source_dir)"
}

check_path() {
    if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
        log_warn "$INSTALL_DIR is not in your PATH"
        echo ""
        echo "Add to your shell config (~/.bashrc or ~/.zshrc):"
        echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
        echo ""
    fi
}

main() {
    echo ""
    echo "=========================================="
    echo "       claude-env installer"
    echo "  Run Claude with .env files loaded"
    echo "=========================================="
    echo ""

    check_git
    check_dependencies

    # Determine installation source
    local source_dir
    if source_dir=$(detect_install_source); then
        log_info "Installing from local repository: $source_dir"
    else
        log_info "Installing from remote repository"
        clone_or_update_repo
        source_dir="$REPO_DIR"
    fi

    install_script "$source_dir"
    check_path

    echo ""
    log_info "Installation complete!"
    echo ""
    echo "Quick start:"
    echo "  1. Create a .env file: echo 'MY_VAR=value' > .env"
    echo "  2. Run Claude: claude-env"
    echo "  3. Verify setup: claude-env --check"
    echo ""
    echo "Update anytime with:"
    echo "  claude-env --upgrade"
    echo ""
}

main "$@"
