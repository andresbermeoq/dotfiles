SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

# Variables
DOTFILES_SKIP_PKGS ?= 0
BOOTSTRAP := ./install/bootstrap.sh
DIRS_ALL := zsh nvim kitty starship vscode
DIRS := $(shell for d in $(DIRS_ALL); do test -d $$d && echo $$d; done)

.PHONY: help bootstrap bootstrap-docker link lint fmt ci deps print-%

help: ## Makefile commands (auto)
	@printf "\nCommands:\n"
	@grep -E '^[a-zA-Z0-9_.-]+:.*##' $(MAKEFILE_LIST) \
	| sed -E 's/^([a-zA-Z0-9_.-]+):.*##[[:space:]]*(.*)$$/\1\t\2/' \
	| awk -F'\t' '{printf "  \033[32m%-16s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Vars:"
	@echo "  DOTFILES_SKIP_PKGS=$(DOTFILES_SKIP_PKGS)"

bootstrap: ## Execute bootstrap (install pkgs unless skipped) and stow links.
	DOTFILES_SKIP_PKGS=$(DOTFILES_SKIP_PKGS) bash $(BOOTSTRAP)

bootstrap-docker: ## Bootstrap in Docker (skip package installation)
	DOTFILES_SKIP_PKGS=1 bash $(BOOTSTRAP)

link: ## Create symlinks with stow for existing dirs.
	@command -v stow >/dev/null 2>&1 || { echo "stow not found"; exit 1; }
	@test -n "$(DIRS)" || { echo "No linkable dirs in $(DIRS_ALL)"; exit 0; }
	stow -v -t "$$HOME" $(DIRS)

lint: ## Lint shell scripts and Lua files (only if files exist)
	@sh -c 'set -e; \
	  if command -v shellcheck >/dev/null 2>&1; then \
	    f=$$(find scripts -type f -name "*.sh" 2>/dev/null | tr "\n" " "); \
	    [ -n "$$f" ] && shellcheck $$f || true; \
	  fi'
	@sh -c 'set -e; \
	  command -v shfmt >/dev/null 2>&1 && \
	  f=$$(find scripts -type f -name "*.sh" 2>/dev/null | tr "\n" " "); \
	  [ -n "$$f" ] && shfmt -d scripts || true'
	@sh -c 'command -v stylua >/dev/null 2>&1 && [ -d nvim ] && stylua --check nvim || true'

fmt: ## Auto-format shell scripts and Lua files (only if files exist)
	@sh -c 'command -v shfmt >/dev/null 2>&1 && [ -d scripts ] && shfmt -w scripts || true'
	@sh -c 'command -v stylua >/dev/null 2>&1 && [ -d nvim ] && stylua nvim || true'

ci: lint ## CI smoke (lint + versions)
	@zsh -i -c 'echo $$ZSH_VERSION' || true
	@nvim --version | head -n 1 || true

deps: ## Check basic deps
	@for b in stow zsh nvim; do \
	  if command -v $$b >/dev/null 2>&1; then \
	    printf "  \033[32m[ok]\033[0m %s\n" "$$b"; \
	  else \
	    printf "  \033[33m[missing]\033[0m %s\n" "$$b"; \
	  fi; \
	done

print-%: ## Print a variable value (usage: make print-VAR)
	@echo "$*=$($*)"
