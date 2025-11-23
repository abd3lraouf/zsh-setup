#!/bin/zsh
# Module: Git Configuration
# Description: Configure git user, aliases, and settings


run_module() {
  echo "Git Configuration..."

  if ! command -v git &>/dev/null; then
    print_error "Git not installed, skipping configuration"
    return
  fi

  # Check if git is already configured
  local current_name=$(git config --global user.name 2>/dev/null)
  local current_email=$(git config --global user.email 2>/dev/null)

  if [[ -n "$current_name" && -n "$current_email" ]]; then
    print_success "Git already configured as: $current_name <$current_email>"
    if ! ask "  Reconfigure git?" "n"; then
      return
    fi
  fi

  if ask "  Configure git user?" "y"; then
    # Get user name
    echo -n "    Enter your name: "
    read git_name
    if [[ -n "$git_name" ]]; then
      git config --global user.name "$git_name"
    fi

    # Get user email
    echo -n "    Enter your email: "
    read git_email
    if [[ -n "$git_email" ]]; then
      git config --global user.email "$git_email"
    fi

    print_success "Git user configured"
  fi

  if ask "  Set up recommended git settings?" "y"; then
    # Default branch
    git config --global init.defaultBranch main

    # Better diffs
    git config --global diff.algorithm histogram

    # Auto-correct typos
    git config --global help.autocorrect 10

    # Rebase on pull
    git config --global pull.rebase true

    # Prune on fetch
    git config --global fetch.prune true

    # Better merge conflict style
    git config --global merge.conflictstyle zdiff3

    # Push current branch by default
    git config --global push.default current
    git config --global push.autoSetupRemote true

    # Color output
    git config --global color.ui auto

    print_success "Git settings configured"
  fi

  if ask "  Add useful git aliases?" "y"; then
    # Status shortcuts
    git config --global alias.s "status -sb"
    git config --global alias.st "status"

    # Log shortcuts
    git config --global alias.l "log --oneline -20"
    git config --global alias.lg "log --graph --oneline --decorate"
    git config --global alias.last "log -1 HEAD --stat"

    # Branch shortcuts
    git config --global alias.br "branch"
    git config --global alias.co "checkout"
    git config --global alias.cb "checkout -b"

    # Commit shortcuts
    git config --global alias.cm "commit -m"
    git config --global alias.ca "commit --amend"
    git config --global alias.can "commit --amend --no-edit"

    # Diff shortcuts
    git config --global alias.d "diff"
    git config --global alias.ds "diff --staged"

    # Other useful aliases
    git config --global alias.undo "reset HEAD~1 --mixed"
    git config --global alias.unstage "reset HEAD --"
    git config --global alias.aliases "config --get-regexp alias"

    print_success "Git aliases added (run 'git aliases' to see them)"
  fi
}

run_module
