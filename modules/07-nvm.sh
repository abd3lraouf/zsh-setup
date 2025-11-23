#!/bin/zsh
# Module: NVM
# Description: Install Node Version Manager


run_module() {
  # Main script already printed step header
  echo "NVM (Node Version Manager)..."

  # Export for other modules
  export NVM_INSTALLED=false

  if [[ -d "$HOME/.nvm" ]] || [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
    print_success "NVM already installed"
    export NVM_INSTALLED=true
  else
    if command -v brew &>/dev/null && ask "  Install NVM via Homebrew?" "y"; then
      echo "  Installing NVM..."
      brew install nvm
      mkdir -p "$HOME/.nvm"
      export NVM_DIR="$HOME/.nvm"
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
      print_success "NVM installed"
      export NVM_INSTALLED=true
    else
      print_warning "Skipping NVM"
    fi
  fi
}

run_module
