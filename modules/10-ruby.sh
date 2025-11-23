#!/bin/zsh
# Module: Ruby
# Description: Install Ruby via rbenv and CocoaPods


run_module() {
  # Main script already printed step header
  echo "Ruby (via rbenv)..."
  RBENV_INSTALLED=false

  if command -v rbenv &>/dev/null; then
    print_success "rbenv already installed"
    RBENV_INSTALLED=true
  else
    if command -v brew &>/dev/null && ask "  Install rbenv via Homebrew?" "y"; then
      echo "  Installing rbenv and ruby-build..."
      brew install rbenv ruby-build
      eval "$(rbenv init - zsh)"
      print_success "rbenv installed"
      RBENV_INSTALLED=true
    else
      print_warning "Skipping rbenv"
    fi
  fi

  # Install Ruby via rbenv
  if $RBENV_INSTALLED; then
    # Initialize rbenv
    eval "$(rbenv init - zsh)"

    # Check if any Ruby is installed
    CURRENT_RUBY=$(rbenv global 2>/dev/null)
    if [[ "$CURRENT_RUBY" == "system" ]] || [[ -z "$CURRENT_RUBY" ]]; then
      echo ""
      print_warning "No Ruby version set"
      if ask "  Install latest stable Ruby?" "y"; then
        echo "  Finding latest stable Ruby version..."
        # Get latest stable version (exclude -dev, -preview, -rc)
        LATEST_RUBY=$(rbenv install -l 2>/dev/null | grep -E '^\s*[0-9]+\.[0-9]+\.[0-9]+\s*$' | tail -1 | tr -d ' ')

        if [[ -n "$LATEST_RUBY" ]]; then
          echo "  Installing Ruby $LATEST_RUBY..."
          print_time_estimate "5-10 minutes"
          rbenv install "$LATEST_RUBY"
          rbenv global "$LATEST_RUBY"
          print_success "Ruby $LATEST_RUBY installed and set as global"

          # Install CocoaPods
          echo ""
          if ask "  Install CocoaPods?" "y"; then
            echo "  Installing CocoaPods..."
            gem install cocoapods
            print_success "CocoaPods installed"
          else
            print_warning "Skipping CocoaPods"
          fi
        else
          print_error "Could not find latest Ruby version"
        fi
      else
        print_warning "Skipping Ruby installation"
      fi
    else
      print_success "Current Ruby: $CURRENT_RUBY"

      # Offer CocoaPods if not installed
      if ! command -v pod &>/dev/null; then
        if ask "  Install CocoaPods?" "y"; then
          echo "  Installing CocoaPods..."
          gem install cocoapods
          print_success "CocoaPods installed"
        else
          print_warning "Skipping CocoaPods"
        fi
      else
        print_success "CocoaPods already installed"
      fi
    fi
  fi
}

run_module
