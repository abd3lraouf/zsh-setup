#!/bin/zsh
# Module: Python Setup
# Description: Install pyenv and Python


run_module() {
  echo "Python Setup..."

  # Check if pyenv is installed
  if command -v pyenv &>/dev/null; then
    print_success "pyenv already installed"
    local current_version=$(pyenv version-name 2>/dev/null)
    if [[ -n "$current_version" && "$current_version" != "system" ]]; then
      print_info "Current Python: $current_version"
    fi
  else
    if ask "  Install pyenv?" "y"; then
      if command -v brew &>/dev/null; then
        echo "  Installing pyenv..."
        brew install pyenv --quiet

        # Add pyenv to shell
        if ! grep -q 'pyenv init' ~/.zprofile 2>/dev/null; then
          cat >> ~/.zprofile << 'EOF'

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
        fi

        # Initialize pyenv for current session
        export PYENV_ROOT="$HOME/.pyenv"
        [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
        eval "$(pyenv init -)"

        print_success "pyenv installed"
      else
        print_error "Homebrew required for pyenv installation"
        return
      fi
    else
      print_warning "Skipping pyenv"
      return
    fi
  fi

  # Install Python version
  if command -v pyenv &>/dev/null; then
    if ask "  Install a Python version?" "y"; then
      # Get available versions
      echo "  Fetching available Python versions..."
      local versions=($(pyenv install --list 2>/dev/null | grep -E '^\s*3\.(11|12|13)\.[0-9]+$' | tail -6 | tr -d ' '))

      if [[ ${#versions[@]} -eq 0 ]]; then
        print_error "Could not fetch Python versions"
        return
      fi

      echo "  Available versions:"
      local i=1
      for version in "${versions[@]}"; do
        echo "    $i) $version"
        ((i++))
      done

      echo -n "  Select version (1-${#versions[@]}): "
      read selection

      if [[ "$selection" =~ ^[0-9]+$ ]] && [[ $selection -ge 1 ]] && [[ $selection -le ${#versions[@]} ]]; then
        local selected_version="${versions[$selection]}"

        # Check if already installed
        if pyenv versions --bare | grep -q "^${selected_version}$"; then
          print_success "Python $selected_version already installed"
        else
          echo "  Installing Python $selected_version (this may take a few minutes)..."
          pyenv install "$selected_version"
          print_success "Python $selected_version installed"
        fi

        if ask "  Set Python $selected_version as global default?" "y"; then
          pyenv global "$selected_version"
          print_success "Python $selected_version set as global default"
        fi
      else
        print_warning "Invalid selection, skipping Python installation"
      fi
    fi

    # Install common packages
    if ask "  Install common Python packages (pip, pipx)?" "y"; then
      # Upgrade pip
      python -m pip install --upgrade pip --quiet 2>/dev/null

      # Install pipx for isolated CLI tools
      python -m pip install --user pipx --quiet 2>/dev/null
      python -m pipx ensurepath --quiet 2>/dev/null

      print_success "pip upgraded, pipx installed"
    fi
  fi
}

run_module
