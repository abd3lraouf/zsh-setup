#!/bin/zsh
# Module: issue2md
# Description: Install issue2md for GitHub issue conversion


run_module() {
  # Main script already printed step header
  echo "issue2md (for ghissue2md function)..."
  if command -v issue2md &>/dev/null; then
    print_success "issue2md already installed"
  else
    if command -v go &>/dev/null && ask "  Install issue2md via Go?" "y"; then
      echo "  Installing issue2md..."
      go install github.com/abd3lraouf/issue2md/cmd/issue2md@latest
      print_success "issue2md installed"
    else
      print_warning "Skipping issue2md"
    fi
  fi
}

run_module
