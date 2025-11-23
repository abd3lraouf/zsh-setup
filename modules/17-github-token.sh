#!/bin/zsh
# Module: GitHub Token
# Description: Configure GitHub token for ghissue2md


run_module() {
  # Main script already printed step header
  echo "GitHub Token..."

  if grep -q "^export GITHUB_TOKEN=" "$HOME/.zprofile" 2>/dev/null; then
    print_success "GitHub token already configured"
  else
    if ask "  Configure GitHub token for ghissue2md?" "n"; then
      echo ""
      echo "  Token options:"
      echo "  1) Create new token (opens GitHub)"
      echo "  2) Enter existing token"
      echo "  3) Skip for now"
      echo ""
      echo "  ${YELLOW}Required scopes for ghissue2md:${NC}"
      echo "    - repo (Full control of private repositories)"
      echo "    - read:user (Read user profile data)"
      echo ""

      echo -n "  Select option [1-3] (default: 1): "
      read token_choice
      token_choice=${token_choice:-1}

      case $token_choice in
        1)
          echo "  Opening GitHub token settings..."
          open "https://github.com/settings/tokens/new?description=ghissue2md&scopes=repo,read:user"
          echo ""
          print_warning "Create a token with 'repo' and 'read:user' scopes"
          echo -n "  Paste your new token here: "
          read new_token
          if [[ -n "$new_token" ]]; then
            echo "export GITHUB_TOKEN=\"$new_token\"" >> "$HOME/.zprofile"
            print_success "Token added to .zprofile"
          else
            print_warning "No token entered, skipping"
          fi
          ;;
        2)
          echo -n "  Enter your GitHub token: "
          read new_token
          if [[ -n "$new_token" ]]; then
            echo "export GITHUB_TOKEN=\"$new_token\"" >> "$HOME/.zprofile"
            print_success "Token added to .zprofile"
          else
            print_warning "No token entered, skipping"
          fi
          ;;
        *)
          print_warning "Skipping GitHub token"
          ;;
      esac
    else
      print_warning "Skipping GitHub token"
    fi
  fi
}

run_module
