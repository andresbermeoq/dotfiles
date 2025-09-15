#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
# Log helper (green)
log() { printf "\033[1;32m[bootstrap]\033[0m %s\n" "$*"; }

# Error
trap 'echo -e "\033[1;31m[bootstrap] Error on line $LINENO\033[0m"' ERR

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
    if ! command -v brew >/dev/null 2>&1; then
        log "Homebrew not found. Installing..."
        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install git stow zsh curl ripgrep fzf
}

if [[ "$SKIP_PKGS" -eq 0 && -n "$SUDO" ]] && ! command -v sudo >/dev/null 2>&1; then
  log "No 'sudo' and not root. In Docker use: DOTFILES_SKIP_PKGS=1 make bootstrap, or execute with root user."
  exit 1
fi

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

if [[ "$SKIP_PKGS" -eq 1 ]] && ! command -v stow >/dev/null 2>&1; then
  log "GNU stow not found. Install or execute DOTFILES_SKIP_PKGS=1."
  exit 1
fi

# ---- OH-MY-ZSH Instalation ------
if [[ "${DOTFILES_INSTALL_OMZ:-1}" == "1" ]]; then
  if [[ -f "$REPO_ROOT/install/omz.sh" ]]; then
    log "Ensuring Oh-My-Zsh is installed..."
    OMZ_FLAGS_STR="${DOTFILES_OMZ_FLAGS:---plugins}"
    read -r -a OMZ_FLAGS_ARR <<< "${OMZ_FLAGS_STR:-}"
    if ! bash "$REPO_ROOT/install/omz.sh" "${OMZ_FLAGS_ARR[@]}"; then
      log "OMZ install skipped/failed (network/policy). Continuing..."
    fi
  else
    log "install/omz.sh not found or not executable; skipping OMZ."
  fi
else
  log "Skipping OMZ install (DOTFILES_INSTALL_OMZ=0)."
fi

if [[ -f "$HOME/.zshrc" && ! -L "$HOME/.zshrc" && -f "$REPO_ROOT/zsh/.zshrc" ]]; then
  log "Backing up ~/.zshrc to ~/.zshrc.pre-stow (to avoid Stow conflicts)"
  mv "$HOME/.zshrc" "$HOME/.zshrc.pre-stow"
fi

log "Stowing dotfiles..."
make link

log "Ready!..... Open a new terminal session to start using zsh! ( ͡° ͜ʖ ͡°)"
