#!/bin/zsh
# Module: macOS Defaults
# Description: Configure macOS settings for developers


run_module() {
  echo "macOS Defaults..."

  if [[ "$(uname)" != "Darwin" ]]; then
    print_warning "Not macOS, skipping"
    return
  fi

  if ! ask "  Apply developer-friendly macOS settings?" "y"; then
    print_warning "Skipping macOS defaults"
    return
  fi

  echo "  Applying settings..."

  # Finder settings
  if ask "    Finder: Show hidden files?" "y"; then
    defaults write com.apple.finder AppleShowAllFiles -bool true
  fi

  if ask "    Finder: Show file extensions?" "y"; then
    defaults write NSGlobalDomain AppleShowAllExtensions -bool true
  fi

  if ask "    Finder: Show path bar?" "y"; then
    defaults write com.apple.finder ShowPathbar -bool true
  fi

  if ask "    Finder: Show status bar?" "y"; then
    defaults write com.apple.finder ShowStatusBar -bool true
  fi

  # Keyboard settings
  if ask "    Keyboard: Faster key repeat?" "y"; then
    # KeyRepeat: 3 = fast but not too aggressive (default is 6)
    # InitialKeyRepeat: 25 = normal delay before repeat starts (default is 25)
    defaults write NSGlobalDomain KeyRepeat -int 3
    defaults write NSGlobalDomain InitialKeyRepeat -int 20
  fi

  if ask "    Keyboard: Disable auto-correct?" "n"; then
    defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
  fi

  # Dock settings
  if ask "    Dock: Auto-hide?" "n"; then
    defaults write com.apple.dock autohide -bool true
  fi

  if ask "    Dock: Remove delay when hiding?" "y"; then
    defaults write com.apple.dock autohide-delay -float 0
    defaults write com.apple.dock autohide-time-modifier -float 0.3
  fi

  # Screenshots
  if ask "    Screenshots: Save to ~/Screenshots?" "y"; then
    mkdir -p ~/Screenshots
    defaults write com.apple.screencapture location -string "${HOME}/Screenshots"
  fi

  if ask "    Screenshots: Disable shadow?" "y"; then
    defaults write com.apple.screencapture disable-shadow -bool true
  fi

  # Development settings
  if ask "    Show ~/Library folder?" "y"; then
    chflags nohidden ~/Library
  fi

  if ask "    Disable .DS_Store on network volumes?" "y"; then
    defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  fi

  # Apply changes
  echo "  Restarting affected apps..."
  killall Finder 2>/dev/null
  killall Dock 2>/dev/null
  killall SystemUIServer 2>/dev/null

  print_success "macOS defaults applied"
  print_info "Some changes may require logout/restart"
}

run_module
