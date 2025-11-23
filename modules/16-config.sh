#!/bin/zsh
# Module: Configuration
# Description: Generate and install configuration files


run_module() {
  # Main script already printed step header
  echo "Copying configuration files..."

  # Backup existing files
  if [[ -f "$HOME/.zshrc" ]]; then
    cp "$HOME/.zshrc" "$HOME/.zshrc.backup.$(date +%Y%m%d%H%M%S)"
    echo "  Backed up existing .zshrc"
  fi

  if [[ -f "$HOME/.zprofile" ]]; then
    cp "$HOME/.zprofile" "$HOME/.zprofile.backup.$(date +%Y%m%d%H%M%S)"
    echo "  Backed up existing .zprofile"
  fi

  if [[ -f "$HOME/.p10k.zsh" ]]; then
    cp "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.backup.$(date +%Y%m%d%H%M%S)"
    echo "  Backed up existing .p10k.zsh"
  fi

  # Generate .zshrc with selected plugins
  PLUGIN_LIST=$(echo "$SELECTED_PLUGINS" | tr '|' ' ')

  cat > "$HOME/.zshrc" << 'ZSHRC_EOF'
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="powerlevel10k/powerlevel10k"

# Which plugins would you like to load?
ZSHRC_EOF

  echo "plugins=(git $PLUGIN_LIST)" >> "$HOME/.zshrc"

  cat >> "$HOME/.zshrc" << 'ZSHRC_EOF'

source $ZSH/oh-my-zsh.sh

# Homebrew completions
if type brew &>/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
  autoload -Uz compinit
  compinit
fi

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

# Language settings
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Default editor
export EDITOR='nvim'

# Zoxide (smart cd)
if command -v zoxide &>/dev/null; then
  eval "$(zoxide init zsh)"
fi

# Convert GitHub issue to markdown and copy to clipboard
ghissue2md() {
  if [[ -z "$1" ]]; then
    echo "Error: Please provide a GitHub URL"
    echo "Usage: ghissue2md <github-url>"
    return 1
  fi

  if [[ ! "$1" =~ ^https?://github\.com/ ]]; then
    echo "Warning: URL doesn't appear to be a GitHub URL"
  fi

  if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "Error: GITHUB_TOKEN not set. Add 'export GITHUB_TOKEN=your_token' to ~/.zprofile"
    return 1
  fi

  if issue2md -enable-reactions -enable-user-links -token "$GITHUB_TOKEN" "$1" | pbcopy; then
    echo "Markdown copied to clipboard"
  else
    echo "Error: Failed to convert issue"
    return 1
  fi
}

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Ruby (rbenv)
if command -v rbenv &>/dev/null; then
  eval "$(rbenv init - zsh)"
fi

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# Local bin
export PATH="$HOME/.local/bin:$PATH"

# Common aliases
alias ll="ls -lah"
alias la="ls -A"
alias l="ls -CF"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"
alias -- -="cd -"

# Make directory and cd into it
mkcd() { mkdir -p "$1" && cd "$1"; }

# Quick edit configs
alias zshrc="$EDITOR ~/.zshrc"
alias p10krc="$EDITOR ~/.p10k.zsh"

# Safety nets
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# Modern tool aliases (if installed)
command -v bat &>/dev/null && alias cat="bat"
command -v eza &>/dev/null && alias ls="eza" && alias ll="eza -lah" && alias tree="eza --tree"

# Git shortcuts
alias g="git"
alias gs="git status -sb"
alias gd="git diff"
alias gc="git commit"
alias gp="git push"
alias gl="git pull"

# Claude
alias clauded="claude --dangerously-skip-permissions --verbose"

# Go
export PATH="${PATH}:$(go env GOPATH 2>/dev/null)/bin"

# To customize prompt, run 'p10k configure' or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
ZSHRC_EOF

  echo "  Generated .zshrc with selected plugins"

  # Copy .zprofile
  cp "$RESOURCES_DIR/.zprofile" "$HOME/.zprofile"
  echo "  Installed .zprofile"

  # Copy p10k config if exists
  if [[ -f "$RESOURCES_DIR/.p10k.zsh" ]]; then
    cp "$RESOURCES_DIR/.p10k.zsh" "$HOME/.p10k.zsh"
    echo "  Installed .p10k.zsh"
  fi

  print_success "Configuration installed"
}

run_module
