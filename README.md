# Dotfiles — Andres Bermeo

[![dotfiles-ci](https://github.com/andresbermeoq/dotfiles/actions/workflows/dotfiles-ci.yml/badge.svg?branch=main)](https://github.com/andresbermeoq/dotfiles/actions/workflows/dotfiles-ci.yml)

Reproducible dotfiles for **Zsh**, **Neovim**, **Kitty**, **Starship**, and **VS Code**.
Includes an idempotent **bootstrap**, symlink management via **GNU Stow**, and optional **Oh-My-Zsh** install.

---

## What’s inside

- **Zsh**: compact `.zshrc` (OMZ optional), cached completion, handy aliases, **pyenv**, **lazy NVM** (with a message when switching versions).
- **Neovim**: Treesitter, LSP, Telescope, format/lint, DAP, etc. (in `~/.config/nvim`).
- **Kitty**: Catppuccin theme include, powerline tabs, dynamic opacity, fullscreen/maximize bindings.
- **Starship**: fast prompt with Poimandres palette, modules for Git, Node (NVM), Python (pyenv), Rust, Go, and **custom Angular** module.
- **VS Code**: sensible user settings.
- **CI**: basic lint + smoke test.

---

## Requirements

- **Linux (Debian/Ubuntu)** or **macOS**.
- Base packages (bootstrap can install them):
  `git stow zsh curl ripgrep fzf neovim`
- Optional but recommended: **Oh-My-Zsh**, **Starship**, a **Nerd Font** (for powerline symbols).

---

## Quick start

```bash
git clone https://github.com/andresbermeoq/dotfiles.git ~/dotfiles
cd ~/dotfiles
make bootstrap
# then open a new terminal (or: exec zsh -l)
```

By default, the bootstrap attempts to install system deps (where possible), symlinks configs under `~/.config/...`, and runs the optional OMZ installer if present.

---

## Make commands

```bash
make help       # list documented targets
make bootstrap  # install deps (if allowed), OMZ (optional), and stow links
make link       # (re)create symlinks with Stow
make lint       # shellcheck / shfmt / stylua (if available)
make fmt        # format shell scripts and lua
make ci         # local smoke test
make deps       # check basic binaries
```

---

## Environment variables

- `DOTFILES_SKIP_PKGS=1`
  Skip OS package installation (handy in Docker/CI).

- `DOTFILES_INSTALL_OMZ=0|1` (default: `1`)
  Whether to install **Oh-My-Zsh**.

- `DOTFILES_OMZ_FLAGS="--plugins --set-default"`
  Flags forwarded to `install/omz.sh`. Default is `--plugins`.
  > `--set-default` attempts `chsh` (usually not applicable inside Docker).

Examples:
```bash
DOTFILES_SKIP_PKGS=1 make bootstrap
DOTFILES_INSTALL_OMZ=0 make bootstrap
DOTFILES_OMZ_FLAGS="--plugins --set-default" make bootstrap
```

---

## Stow layout (target = `$HOME`)

The repo is shaped so Stow places everything under `~/.config/...` where appropriate:

```
zsh/
 ├─ .zshrc                  -> ~/.zshrc
 └─ .zprofile               -> ~/.zprofile

nvim/
 └─ .config/nvim/...        -> ~/.config/nvim/...

kitty/
 └─ .config/kitty/...       -> ~/.config/kitty/...

starship/
 └─ .config/starship.toml   -> ~/.config/starship.toml

vscode/
 └─ .config/Code/User/settings.json -> ~/.config/Code/User/settings.json
```

> If a real `~/.zshrc` existed, the bootstrap backs it up as `~/.zshrc.pre-stow` to avoid conflicts.

---

## Oh-My-Zsh (optional)

The bootstrap will call `install/omz.sh` if the script exists:

```bash
./install/omz.sh                 # OMZ only
./install/omz.sh --plugins       # + common external plugins
./install/omz.sh --set-default   # try to set zsh as default login shell
```

`.zshrc` loads OMZ **only if it exists**, so the shell won’t break if you skip it.

---

## Neovim

1) Install Neovim (`apt`/`brew` or official release).
2) Run `make link` or `make bootstrap`.
3) Launch `nvim` and let the plugin manager install dependencies.

---

## Kitty

- Config lives in `~/.config/kitty/kitty.conf`.
- Keybindings: `Ctrl+Shift+F` (fullscreen), `Ctrl+Shift+M` (maximize), `Ctrl+Shift+C/V` (copy/paste), `Ctrl+Shift+E` (URL hints).
- **Start in fullscreen**: launch Kitty with `--start-as=fullscreen` (set it in your launcher/`.desktop`).

---

## Starship

- Config in `~/.config/starship.toml` with Poimandres palette.
- Modules: Git, Node (NVM), Python (pyenv), Rust, Go, and **custom Angular**.
- Use a **Nerd Font** in your terminal to render symbols correctly.

---

## Optional: test in Docker

Minimal `Dockerfile` (Ubuntu 24.04):

```dockerfile
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends     git make stow zsh curl ripgrep fzf neovim ca-certificates locales  && rm -rf /var/lib/apt/lists/* && locale-gen en_US.UTF-8
RUN useradd -ms /bin/bash andres
USER andres
WORKDIR /home/andres/dotfiles
CMD ["/bin/bash"]
```

Quick test:
```bash
docker build -t dotfiles-test .
docker run --rm -it -v "$PWD":/home/andres/dotfiles dotfiles-test bash -lc '
  cd ~/dotfiles
  DOTFILES_SKIP_PKGS=1 DOTFILES_INSTALL_OMZ=1 DOTFILES_OMZ_FLAGS="--plugins" make bootstrap
  exec zsh -l
'
```

---

## Troubleshooting

- **Stow conflicts** (`existing target is neither a link`):
  ```bash
  stow -D -v -t "$HOME" <package>
  mv <file> <file>.pre-stow
  stow -v -R -t "$HOME" <package>
  ```

- **OMZ not loading**
  `test -f ~/.oh-my-zsh/oh-my-zsh.sh && echo OK || echo NO`
  Reinstall: `bash install/omz.sh --plugins`

- **NVM not switching**
  Ensure a readable `.nvmrc` exists. You’ll see a message like:
  `🔄 NVM: changed from X → Y (via .nvmrc in <cwd>)`

- **Weird glyphs**
  Install and select a **Nerd Font** in your terminal.

---

## Uninstall / clean up

```bash
# remove symlinks
stow -D -v -t "$HOME" zsh nvim kitty starship vscode

# restore previous zshrc if backup exists
[ -f ~/.zshrc.pre-stow ] && mv ~/.zshrc.pre-stow ~/.zshrc

# remove OMZ (optional)
rm -rf ~/.oh-my-zsh
```

---

## License

See `LICENSE`. Adapt freely to your workflow.
