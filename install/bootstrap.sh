#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'
log() { printf "\033[1;32m[bootstrap]\033[0m %s\n" "$*"; }

# Define the SUDO user
if [[ $EUID -eq 0 ]]; then
    SUDO=""
else
    SUDO="sudo "
fi

# Allow skipping package installation in docker.
if [[ "${DOTFILES_SKIP_PKGS:-0}" == "1" ]]; then
  log "[bootstrap] Skipping Installation in the (DOTFILES_SKIP_PKGS=1)"
  SKIP_PKGS=1
else
  SKIP_PKGS=0
fi

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"

ensure_pkg_linux() {
    ${SUDO}apt-get update -y
    ${SUDO}apt-get install -y git stow zsh curl ripgrep fzf
}
ensure_pkg_macos() {
    if ! command -v brew > dev/null 2>&1; then
        log "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install git stow zsh curl ripgrep fzf
}

if [[ "$SKIP_PKGS" -eq 0 ]]; then
    log "Ensuring required packages are installed..."
    case "$OS" in
        linux*) ensure_pkg_linux ;;
        darwin*) ensure_pkg_macos ;;
        *) log "Unsupported OS: $OS" && exit 1 ;;
    esac
else
    log "Skipping package installation as per DOTFILES_SKIP_PKGS"
fi

log "Creating structures..."
mkdir -p "$HOME/.config"

log "Stowing dotfiles..."
make link

log "Ready!..... Open a new terminal session to start using zsh! ( ͡° ͜ʖ ͡°)"
