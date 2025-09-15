#Global PATH
export PYENV_ROOT="$HOME/.pyenv"
case "$PATH" in *"$PYENV_ROOT/bin"*) ;; *) PATH="$PYENV_ROOT/bin:$PATH" ;; esac
command -v pyenv >/dev/null && eval "$(pyenv init --path)"


# Routes 
