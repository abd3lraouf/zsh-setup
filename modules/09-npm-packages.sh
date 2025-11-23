#!/bin/zsh
# Module: npm Global Packages
# Description: Install global npm packages


run_module() {
  # Main script already printed step header
  echo "npm global packages..."

  # Check if npm is available
  NVM_AVAILABLE=false
  if [[ -d "$HOME/.nvm" ]] || [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    NVM_AVAILABLE=true
  fi

  if command -v npm &>/dev/null || $NVM_AVAILABLE; then
    if command -v npm &>/dev/null; then
      NPM_PACKAGES_TO_INSTALL=()

      echo "  Checking packages..."

      # Claude CLI
      if ! command -v claude &>/dev/null; then
        NPM_PACKAGES_TO_INSTALL+=("@anthropic-ai/claude-code")
        echo "    claude: ${YELLOW}not installed${NC}"
      else
        echo "    claude: ${GREEN}installed${NC}"
      fi

      # TypeScript
      if ! command -v tsc &>/dev/null; then
        NPM_PACKAGES_TO_INSTALL+=("typescript")
        echo "    typescript: ${YELLOW}not installed${NC}"
      else
        echo "    typescript: ${GREEN}installed${NC}"
      fi

      # Prettier
      if ! command -v prettier &>/dev/null; then
        NPM_PACKAGES_TO_INSTALL+=("prettier")
        echo "    prettier: ${YELLOW}not installed${NC}"
      else
        echo "    prettier: ${GREEN}installed${NC}"
      fi

      # ESLint
      if ! command -v eslint &>/dev/null; then
        NPM_PACKAGES_TO_INSTALL+=("eslint")
        echo "    eslint: ${YELLOW}not installed${NC}"
      else
        echo "    eslint: ${GREEN}installed${NC}"
      fi

      # tldr - simplified man pages
      if ! command -v tldr &>/dev/null; then
        NPM_PACKAGES_TO_INSTALL+=("tldr")
        echo "    tldr: ${YELLOW}not installed${NC}"
      else
        echo "    tldr: ${GREEN}installed${NC}"
      fi

      if [[ ${#NPM_PACKAGES_TO_INSTALL[@]} -gt 0 ]]; then
        echo ""
        if ask "  Install missing packages (${NPM_PACKAGES_TO_INSTALL[*]})?" "y"; then
          echo "  Installing packages..."
          npm install -g ${NPM_PACKAGES_TO_INSTALL[@]}
          print_success "Packages installed"
        else
          print_warning "Skipping packages"
        fi
      else
        print_success "All packages already installed"
      fi
    else
      print_warning "npm not available"
    fi
  else
    print_warning "Skipping (Node.js not installed)"
  fi
}

run_module
