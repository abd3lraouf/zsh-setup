#!/bin/zsh
# Module: ZSH Plugins
# Description: Select and install Oh My Zsh plugins


run_module() {
  # Main script already printed step header
  echo "Selecting plugins..."
  echo ""
  echo "  ${BOLD}Select plugins to install:${NC}"
  echo ""

  # Plugin options with descriptions
  PLUGIN_OPTIONS=(
    "zsh-autosuggestions      - Fish-like suggestions"
    "zsh-syntax-highlighting  - Command syntax coloring"
    "zsh-history-substring-search - Fish-like history search"
    "zsh-completions          - Additional completions"
    "you-should-use           - Alias reminders"
    "zsh-bat                  - Use bat for cat/less"
    "sudo                     - ESC twice to add sudo"
    "copypath                 - Copy current path"
    "copyfile                 - Copy file contents"
    "extract                  - Extract any archive"
    "web-search               - Search from terminal"
    "jsontools                - JSON formatting tools"
    "docker                   - Docker completions"
    "docker-compose           - Docker Compose completions"
    "npm                      - npm completions"
    "kubectl                  - Kubernetes completions"
    "aws                      - AWS completions"
    "macos                    - macOS utilities"
  )

  # Detect installed plugins
  ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
  OMZ_DIR="$HOME/.oh-my-zsh"

  # Build list of installed plugins
  INSTALLED_PLUGINS=""

  # Plugin names to check
  PLUGIN_NAMES=(
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "zsh-history-substring-search"
    "zsh-completions"
    "you-should-use"
    "zsh-bat"
    "sudo"
    "copypath"
    "copyfile"
    "extract"
    "web-search"
    "jsontools"
    "docker"
    "docker-compose"
    "npm"
    "kubectl"
    "aws"
    "macos"
  )

  for plugin in "${PLUGIN_NAMES[@]}"; do
    # Check if custom plugin is installed
    if [[ -d "$ZSH_CUSTOM/plugins/$plugin" ]]; then
      if [[ -n "$INSTALLED_PLUGINS" ]]; then
        INSTALLED_PLUGINS="${INSTALLED_PLUGINS}|${plugin}"
      else
        INSTALLED_PLUGINS="${plugin}"
      fi
    # Check if built-in plugin exists
    elif [[ -d "$OMZ_DIR/plugins/$plugin" ]]; then
      if [[ -n "$INSTALLED_PLUGINS" ]]; then
        INSTALLED_PLUGINS="${INSTALLED_PLUGINS}|${plugin}"
      else
        INSTALLED_PLUGINS="${plugin}"
      fi
    fi
  done

  # Use installed plugins as defaults, or fallback to recommended if none installed
  if [[ -n "$INSTALLED_PLUGINS" ]]; then
    DEFAULT_PLUGINS="$INSTALLED_PLUGINS"
  else
    DEFAULT_PLUGINS="zsh-autosuggestions|zsh-syntax-highlighting|zsh-history-substring-search|you-should-use|zsh-bat|sudo|copypath|extract|macos"
  fi

  # Join options with |
  PLUGIN_OPTIONS_STR=$(IFS='|'; echo "${PLUGIN_OPTIONS[*]}")

  # Run multiselect
  SELECTED_PLUGINS=""
  multiselect SELECTED_PLUGINS "$PLUGIN_OPTIONS_STR" "$DEFAULT_PLUGINS"

  echo "  Selected plugins: ${GREEN}$(echo $SELECTED_PLUGINS | tr '|' ' ')${NC}"
  echo ""

  # Export for config module
  export SELECTED_PLUGINS

  # Install selected plugins
  echo "Installing plugins..."

  # Custom plugins that need to be cloned
  typeset -A CUSTOM_PLUGINS
  CUSTOM_PLUGINS=(
    zsh-autosuggestions "https://github.com/zsh-users/zsh-autosuggestions"
    zsh-syntax-highlighting "https://github.com/zsh-users/zsh-syntax-highlighting"
    zsh-history-substring-search "https://github.com/zsh-users/zsh-history-substring-search"
    zsh-completions "https://github.com/zsh-users/zsh-completions"
    you-should-use "https://github.com/MichaelAquilina/zsh-you-should-use"
    zsh-bat "https://github.com/fdellwing/zsh-bat"
  )

  # Parse selected plugins
  IFS='|' read -A selected_array <<< "$SELECTED_PLUGINS"

  for plugin in "${selected_array[@]}"; do
    # Check if it's a custom plugin that needs cloning
    if [[ -n "${CUSTOM_PLUGINS[$plugin]}" ]]; then
      PLUGIN_DIR="$ZSH_CUSTOM/plugins/$plugin"
      if [[ -d "$PLUGIN_DIR" ]]; then
        # Check if it's a git repo
        if [[ -d "$PLUGIN_DIR/.git" ]]; then
          run_with_spinner "Updating $plugin..." git -C "$PLUGIN_DIR" pull --quiet
        else
          rm -rf "$PLUGIN_DIR"
          run_with_spinner "Reinstalling $plugin..." git clone --depth=1 "${CUSTOM_PLUGINS[$plugin]}" "$PLUGIN_DIR" --quiet
        fi
      else
        run_with_spinner "Installing $plugin..." git clone --depth=1 "${CUSTOM_PLUGINS[$plugin]}" "$PLUGIN_DIR" --quiet
      fi
    else
      # Built-in oh-my-zsh plugin
      echo "  Using built-in: $plugin"
    fi
  done

  print_success "Plugins installed"
}

run_module
