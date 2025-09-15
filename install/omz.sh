#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

# Logs Helpers
log() { printf "\033[1;32m[omz]\033[0m %s\n" "$*"; }
warn(){ printf "\033[1;33m[omz]\033[0m %s\n" "$*"; }
err() { printf "\033[1;31m[omz]\033[0m %s\n" "$*"; }


INSTALL_PLUGINS=false
SET_DEFAULT=false
CURRENT_USER="${USER:-$(id -un 2>/dev/null || whoami || echo "")}"
for arg in "$@"; do
  case "$arg" in
    --plugins) INSTALL_PLUGINS=true ;;
    --set-default) SET_DEFAULT=true ;;
    *) err "unknown flag: $arg"; exit 2 ;;
  esac
done

OMZ_DIR="${ZSH:-$HOME/.oh-my-zsh}"
OMZ_SH="$OMZ_DIR/oh-my-zsh.sh"


install_omz() {
  if [[ -f "$OMZ_SH" ]]; then
    log "already installed at $OMZ_DIR"
    return
  fi
  log "installing Oh-My-Zsh (unattended)…"
  # evita abrir zsh, cambiar shell y sobreescribir tu .zshrc stoweado
  RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
    "" --unattended
  [[ -f "$OMZ_SH" ]] || { err "installation failed (no $OMZ_SH)"; exit 1; }
}

install_plugins() {
  [[ -d "$OMZ_DIR" ]] || { warn "OMZ not found, skipping plugins"; return; }
  local ZSH_CUSTOM="${OMZ_DIR}/custom"
  mkdir -p "$ZSH_CUSTOM/plugins"
  declare -A repos=(
    [zsh-autosuggestions]=https://github.com/zsh-users/zsh-autosuggestions
    [zsh-syntax-highlighting]=https://github.com/zsh-users/zsh-syntax-highlighting
    [zsh-completions]=https://github.com/zsh-users/zsh-completions
  )
  for name in "${!repos[@]}"; do
    local dst="$ZSH_CUSTOM/plugins/$name"
    if [[ -d "$dst/.git" ]]; then
      log "plugin $name already present"
    else
      log "cloning $name…"
      git clone --depth=1 "${repos[$name]}" "$dst"
    fi
  done
}

set_zsh_default() {
  if ! command -v zsh >/dev/null 2>&1; then
    warn "zsh not found; cannot set as default"
    return
  fi
  if ! command -v chsh >/dev/null 2>&1; then
    warn "chsh unavailable (ok in docker/ci). Skipping."
    return
  fi
  local current shellpath
  if command -v getent >/dev/null 2>&1 && [ -n "$CURRENT_USER" ]; then
    current="$(getent passwd "$CURRENT_USER" | awk -F: '{print $7}')"
  else
    current="${SHELL:-}"
  fi

  shellpath="$(command -v zsh || true)"

  if [ -n "$shellpath" ] && [ "$current" != "$shellpath" ]; then
    log "changing login shell to $shellpath"
    chsh -s "$shellpath" "${CURRENT_USER:-}" || warn "chsh failed (needs password/policy)"
  else
    log "already using zsh as login shell (or cannot detect)"
  fi
}


#main
install_omz
$INSTALL_PLUGINS && install_plugins
$SET_DEFAULT && set_zsh_default
log "Done OH-MY-ZSH Installation."
