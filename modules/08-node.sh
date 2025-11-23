#!/bin/zsh
# Module: Node.js
# Description: Install Node.js via NVM


run_module() {
  # Main script already printed step header
  echo "Node.js..."

  # Check if NVM is available
  if [[ -d "$HOME/.nvm" ]] || [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
    # Load NVM
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

    if ask "  Install/manage Node.js?" "y"; then
      echo ""
      echo "  Available Node.js versions:"
      echo "  ┌─────────┬─────────────┬──────────────────┐"
      echo "  │ Option  │ Version     │ Status           │"
      echo "  ├─────────┼─────────────┼──────────────────┤"
      echo "  │   1     │ 18.x LTS    │ Maintenance LTS  │"
      echo "  │   2     │ 20.x LTS    │ Active LTS       │"
      echo "  │   3     │ 22.x LTS    │ Current LTS      │"
      echo "  │   4     │ 23.x        │ Current          │"
      echo "  │   5     │ Custom      │ Enter version    │"
      echo "  └─────────┴─────────────┴──────────────────┘"
      echo ""

      echo -n "  Select version [1-5] (default: 3): "
      read node_choice
      node_choice=${node_choice:-3}

      case $node_choice in
        1) NODE_VERSION="18" ;;
        2) NODE_VERSION="20" ;;
        3) NODE_VERSION="22" ;;
        4) NODE_VERSION="23" ;;
        5)
          echo -n "  Enter Node version (e.g., 21, 19, 16): "
          read NODE_VERSION
          ;;
        *)
          print_warning "Invalid choice, using Node 22"
          NODE_VERSION="22"
          ;;
      esac

      if nvm ls "$NODE_VERSION" &>/dev/null; then
        print_success "Node $NODE_VERSION already installed"
      else
        echo "  Installing Node.js $NODE_VERSION..."
        print_time_estimate "1-2 minutes"
        nvm install "$NODE_VERSION"
        print_success "Node.js $NODE_VERSION installed"
      fi

      # Ask to set as default
      current_default=$(nvm alias default 2>/dev/null | grep -oE '[0-9]+' | head -1)
      if [[ "$current_default" != "$NODE_VERSION" ]]; then
        if ask "  Set Node $NODE_VERSION as default?" "y"; then
          nvm alias default "$NODE_VERSION"
          print_success "Node $NODE_VERSION set as default"
        fi
      else
        print_success "Node $NODE_VERSION is already default"
      fi
    else
      print_warning "Skipping Node.js"
    fi
  else
    print_warning "Skipping (NVM not installed)"
  fi
}

run_module
