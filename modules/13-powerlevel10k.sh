#!/bin/zsh
# Module: Powerlevel10k
# Description: Install Powerlevel10k theme


run_module() {
  # Main script already printed step header
  echo "Installing Powerlevel10k theme..."
  P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
  if [[ -d "$P10K_DIR" ]]; then
    # Check if it's a git repo
    if [[ -d "$P10K_DIR/.git" ]]; then
      echo "  Powerlevel10k exists, updating..."
      git -C "$P10K_DIR" pull --quiet
      print_success "Powerlevel10k updated"
    else
      echo "  Powerlevel10k exists but not a git repo, reinstalling..."
      rm -rf "$P10K_DIR"
      git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
      print_success "Powerlevel10k reinstalled"
    fi
  else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
    print_success "Powerlevel10k installed"
  fi
}

run_module
