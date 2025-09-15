# -------------------------- Oh My ZSH -----------------------------------------
export ZSH="$HOME/.oh-my-zsh"
if [ -f "$ZSH/oh-my-zsh.sh" ]; then
    ZSH_THEME=""
    plugins=(
    git
    zsh-interactive-cd
    python
    docker-compose
    docker
    gitignore
    rust
    emoji
    zsh-autosuggestions
    jsontools
    poetry
    )
    source $ZSH/oh-my-zsh.sh
else
    autoload -Uz compinit && compinit
fi

# ---------------------- Completion (with cache) -------------------------------
autoload -Uz compinit && compinit
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompcache"

# ------------------------- Aliases --------------------------------------------
command -v lsd >/dev/null && alias ls='lsd'
alias gm="git commit -S -m"; alias gp="git push"; alias gf="git fetch"

# ------------------------- Docker Helper --------------------------------------
docker_list() { docker ps --format '{{.ID}}: {{.Names}}' | sed '1s/^/👇 Containers 👇\n/'; }

# ----------------------------- GPG --------------------------------------------
export GPG_TTY="$(tty)"

# ----------------------------- Pyenv ------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# ----------------------------- NVM Lazy ---------------------------------------
lazy_nvm() { export NVM_DIR="$HOME/.nvm"; [[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"; }
load-nvmrc() {
  [[ -f .nvmrc && -r .nvmrc ]] || return
  command -v nvm >/dev/null || lazy_nvm
  local want; want="$(<.nvmrc)"; local have; have="$(nvm version)"
  [[ "$have" == "$want" ]] || { nvm ls "$want" >/dev/null 2>&1 || nvm install "$want"; nvm use "$want" --silent; }
}
autoload -U add-zsh-hook; add-zsh-hook chpwd load-nvmrc; load-nvmrc

# ----------------------------- Prompt (Starship) ------------------------------
command -v starship >/dev/null && eval "$(starship init zsh)"
