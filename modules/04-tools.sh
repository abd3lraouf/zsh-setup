#!/bin/zsh
# Module: Developer Tools
# Description: Install CLI tools via Homebrew


run_module() {
  # Main script already printed step header
  echo "Developer tools..."
  if command -v brew &>/dev/null; then
    TOOLS_TO_INSTALL=()

    echo "  Checking tools..."

    # bat - required for zsh-bat plugin
    if ! command -v bat &>/dev/null; then
      TOOLS_TO_INSTALL+=("bat")
      echo "    bat: ${YELLOW}not installed${NC} (required for zsh-bat)"
    else
      echo "    bat: ${GREEN}installed${NC}"
    fi

    # fzf - fuzzy finder
    if ! command -v fzf &>/dev/null; then
      TOOLS_TO_INSTALL+=("fzf")
      echo "    fzf: ${YELLOW}not installed${NC}"
    else
      echo "    fzf: ${GREEN}installed${NC}"
    fi

    # ripgrep - fast grep
    if ! command -v rg &>/dev/null; then
      TOOLS_TO_INSTALL+=("ripgrep")
      echo "    ripgrep: ${YELLOW}not installed${NC}"
    else
      echo "    ripgrep: ${GREEN}installed${NC}"
    fi

    # eza - modern ls
    if ! command -v eza &>/dev/null; then
      TOOLS_TO_INSTALL+=("eza")
      echo "    eza: ${YELLOW}not installed${NC}"
    else
      echo "    eza: ${GREEN}installed${NC}"
    fi

    # zoxide - smart cd
    if ! command -v zoxide &>/dev/null; then
      TOOLS_TO_INSTALL+=("zoxide")
      echo "    zoxide: ${YELLOW}not installed${NC}"
    else
      echo "    zoxide: ${GREEN}installed${NC}"
    fi

    # gh - GitHub CLI
    if ! command -v gh &>/dev/null; then
      TOOLS_TO_INSTALL+=("gh")
      echo "    gh: ${YELLOW}not installed${NC} (GitHub CLI)"
    else
      echo "    gh: ${GREEN}installed${NC}"
    fi

    if [[ ${#TOOLS_TO_INSTALL[@]} -gt 0 ]]; then
      echo ""
      if ask "  Install missing tools (${TOOLS_TO_INSTALL[*]})?" "y"; then
        echo "  Installing tools..."
        brew install ${TOOLS_TO_INSTALL[@]}
        print_success "Tools installed"
      else
        print_warning "Skipping tools"
      fi
    fi
  else
    print_warning "Skipping (Homebrew not installed)"
  fi
}

run_module
