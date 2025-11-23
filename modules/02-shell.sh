#!/bin/zsh
# Module: Shell Setup
# Description: Check and configure default shell


run_module() {
  # Main script already printed step header
  echo "Checking default shell..."
  CURRENT_SHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
  if [[ "$CURRENT_SHELL" != "/bin/zsh" ]]; then
    echo "  Current shell: $CURRENT_SHELL"
    if ask "  Change default shell to zsh?" "y"; then
      chsh -s /bin/zsh
      print_success "Default shell changed to zsh"
    else
      print_warning "Keeping current shell"
    fi
  else
    print_success "Default shell is already zsh"
  fi
}

run_module
