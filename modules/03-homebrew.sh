#!/bin/zsh
# Module: Homebrew
# Description: Install Homebrew package manager


run_module() {
  # Main script already printed step header
  echo "Homebrew..."
  if command -v brew &>/dev/null; then
    print_success "Homebrew already installed"
  else
    if ask "  Install Homebrew?" "y"; then
      echo "  Installing Homebrew..."
      print_time_estimate "2-5 minutes"
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      print_success "Homebrew installed"
    else
      print_warning "Skipping Homebrew"
    fi
  fi
}

run_module
