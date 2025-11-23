#!/bin/zsh
# Module: Oh My Zsh
# Description: Install Oh My Zsh from official repository


run_module() {
  # Main script already printed step header
  echo "Oh My Zsh..."
  if [[ -d "$HOME/.oh-my-zsh" ]]; then
    # Check if it's a git repository
    if [[ -d "$HOME/.oh-my-zsh/.git" ]]; then
      print_success "Oh My Zsh already installed"
      if ask "  Update Oh My Zsh?" "n"; then
        git -C "$HOME/.oh-my-zsh" pull --rebase --quiet
        print_success "Oh My Zsh updated"
      fi
    else
      # Exists but not a git repo (was copied, not cloned)
      print_warning "Oh My Zsh exists but is not a git repository"
      if ask "  Replace with fresh clone from official repo?" "y"; then
        rm -rf "$HOME/.oh-my-zsh"
        echo "  Cloning Oh My Zsh..."
        git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" --quiet
        print_success "Oh My Zsh reinstalled"
      else
        print_warning "Keeping existing Oh My Zsh"
      fi
    fi
  else
    if ask "  Install Oh My Zsh?" "y"; then
      echo "  Cloning Oh My Zsh..."
      git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh" --quiet
      print_success "Oh My Zsh installed"
    else
      print_warning "Skipping Oh My Zsh"
    fi
  fi
}

run_module
