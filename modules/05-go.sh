#!/bin/zsh
# Module: Go
# Description: Install Go programming language


run_module() {
  # Main script already printed step header
  echo "Go..."
  if command -v go &>/dev/null; then
    print_success "Go already installed ($(go version | awk '{print $3}'))"
  else
    if command -v brew &>/dev/null && ask "  Install Go via Homebrew?" "y"; then
      echo "  Installing Go..."
      brew install go
      print_success "Go installed"
    else
      print_warning "Skipping Go"
    fi
  fi
}

run_module
