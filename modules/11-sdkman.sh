#!/bin/zsh
# Module: SDKMAN
# Description: Install SDKMAN, JDK, and macOS Java integration


run_module() {
  # Main script already printed step header
  echo "SDKMAN..."
  SDKMAN_INSTALLED=false

  if [[ -d "$HOME/.sdkman" ]]; then
    print_success "SDKMAN already installed"
    SDKMAN_INSTALLED=true
  else
    if ask "  Install SDKMAN?" "y"; then
      echo "  Installing SDKMAN..."
      curl -s "https://get.sdkman.io" | bash
      print_success "SDKMAN installed"
      SDKMAN_INSTALLED=true
    else
      print_warning "Skipping SDKMAN"
    fi
  fi

  # Install JDK via SDKMAN if none installed
  if $SDKMAN_INSTALLED; then
    # Source SDKMAN
    source "$HOME/.sdkman/bin/sdkman-init.sh"

    # Check if any JDK is set as current
    if [[ ! -L "$HOME/.sdkman/candidates/java/current" ]]; then
      echo ""
      print_warning "No JDK currently set in SDKMAN"
      if ask "  Install a JDK?" "y"; then
        echo ""
        echo "  Select Java version:"
        echo "  ┌─────────┬─────────────┬──────────────────┐"
        echo "  │ Option  │ Version     │ Status           │"
        echo "  ├─────────┼─────────────┼──────────────────┤"
        echo "  │   1     │ 8           │ Legacy LTS       │"
        echo "  │   2     │ 11          │ LTS              │"
        echo "  │   3     │ 17          │ LTS              │"
        echo "  │   4     │ 21          │ Current LTS      │"
        echo "  │   5     │ 23          │ Latest           │"
        echo "  │   6     │ Custom      │ Enter version    │"
        echo "  └─────────┴─────────────┴──────────────────┘"
        echo ""
        echo -n "  Select version [1-6] (default: 4): "
        read java_choice
        java_choice=${java_choice:-4}

        case $java_choice in
          1) JAVA_VERSION="8" ;;
          2) JAVA_VERSION="11" ;;
          3) JAVA_VERSION="17" ;;
          4) JAVA_VERSION="21" ;;
          5) JAVA_VERSION="23" ;;
          6)
            echo -n "  Enter Java version: "
            read JAVA_VERSION
            ;;
          *)
            print_warning "Invalid choice, using 21"
            JAVA_VERSION="21"
            ;;
        esac

        echo ""
        echo "  Select vendor:"
        echo "  ┌─────────┬─────────────────┬──────────────────────┐"
        echo "  │ Option  │ Vendor          │ Identifier           │"
        echo "  ├─────────┼─────────────────┼──────────────────────┤"
        echo "  │   1     │ Amazon Corretto │ amzn                 │"
        echo "  │   2     │ Eclipse Temurin │ tem                  │"
        echo "  │   3     │ Azul Zulu       │ zulu                 │"
        echo "  │   4     │ Oracle          │ oracle               │"
        echo "  │   5     │ GraalVM         │ graal                │"
        echo "  │   6     │ Custom          │ Enter identifier     │"
        echo "  └─────────┴─────────────────┴──────────────────────┘"
        echo ""
        echo -n "  Select vendor [1-6] (default: 1): "
        read vendor_choice
        vendor_choice=${vendor_choice:-1}

        case $vendor_choice in
          1) VENDOR="amzn" ;;
          2) VENDOR="tem" ;;
          3) VENDOR="zulu" ;;
          4) VENDOR="oracle" ;;
          5) VENDOR="graal" ;;
          6)
            echo -n "  Enter vendor identifier: "
            read VENDOR
            ;;
          *)
            print_warning "Invalid choice, using amzn"
            VENDOR="amzn"
            ;;
        esac

        echo ""
        echo "  Finding ${JAVA_VERSION}-${VENDOR}..."

        # Get available versions from SDKMAN API
        PLATFORM="darwinarm64"
        [[ "$(uname -m)" == "x86_64" ]] && PLATFORM="darwinx64"

        # Fetch versions from SDKMAN API and find matching version
        AVAILABLE_VERSION=$(curl -s "https://api.sdkman.io/2/candidates/java/${PLATFORM}/versions/list?installed=" | \
          tr ',' '\n' | \
          grep -o "${JAVA_VERSION}\.[0-9.]*-${VENDOR}" | \
          sort -V | \
          tail -1)

        if [[ -z "$AVAILABLE_VERSION" ]]; then
          # Try alternative pattern for version 8 (uses different format like 8.0.x)
          if [[ "$JAVA_VERSION" == "8" ]]; then
            AVAILABLE_VERSION=$(curl -s "https://api.sdkman.io/2/candidates/java/${PLATFORM}/versions/list?installed=" | \
              tr ',' '\n' | \
              grep -o "8\.[0-9.]*-${VENDOR}" | \
              sort -V | \
              tail -1)
          fi
        fi

        if [[ -n "$AVAILABLE_VERSION" ]]; then
          echo "  Installing Java $AVAILABLE_VERSION..."
          print_time_estimate "1-3 minutes"
          if sdk install java "$AVAILABLE_VERSION" <<< "y"; then
            print_success "Java $AVAILABLE_VERSION installed and set as default"
          else
            print_error "Failed to install Java $AVAILABLE_VERSION"
          fi
        else
          print_error "Could not find ${JAVA_VERSION}-${VENDOR}"
          echo "  Run 'sdk list java | grep ${VENDOR}' to see available versions"
        fi
      else
        print_warning "Skipping JDK installation"
      fi
    else
      CURRENT_JDK=$(basename "$(readlink "$HOME/.sdkman/candidates/java/current")")
      print_success "Current JDK: $CURRENT_JDK"
    fi
  fi

  # SDKMAN macOS Java Integration
  if $SDKMAN_INSTALLED; then
    if [[ -d "/Library/Java/JavaVirtualMachines/sdkman-current" ]]; then
      print_success "SDKMAN-macOS Java integration already installed"
    else
      # Only offer integration if a JDK is set
      if [[ -L "$HOME/.sdkman/candidates/java/current" ]]; then
        echo ""
        echo "  ${BOLD}SDKMAN ↔ macOS Java Integration${NC}"
        echo "  This makes your SDKMAN Java visible to macOS tools like"
        echo "  /usr/libexec/java_home, Xcode, and other native apps."
        echo ""
        if ask "  Install SDKMAN-macOS Java integration?" "y"; then
          echo "  Installing integration (requires sudo)..."
          print_warning "Please enter your password if prompted:"
          # Pre-authenticate sudo before running piped script
          sudo -v
          if [[ $? -eq 0 ]]; then
            curl -fsSL https://gist.githubusercontent.com/abd3lraouf/1db9bf863144802733bfd29bb5dada87/raw/install.sh | bash -s install
            print_success "SDKMAN-macOS integration installed"
          else
            print_error "Sudo authentication failed, skipping integration"
          fi
        else
          print_warning "Skipping integration"
        fi
      else
        print_warning "Skipping macOS integration (no JDK installed)"
      fi
    fi
  fi
}

run_module
