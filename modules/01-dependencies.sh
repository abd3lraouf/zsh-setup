#!/bin/zsh
# Module: Check Dependencies
# Description: Verify required dependencies are installed


run_module() {
  # Main script already printed step header
  echo "Checking dependencies..."
  MISSING_DEPS=()

  if ! command -v git &>/dev/null; then
    MISSING_DEPS+=("git")
  fi

  if ! command -v curl &>/dev/null; then
    MISSING_DEPS+=("curl")
  fi

  if [[ ${#MISSING_DEPS[@]} -gt 0 ]]; then
    print_error "Missing required dependencies: ${MISSING_DEPS[*]}"
    echo "  Please install them first:"
    echo "    xcode-select --install"
    exit 1
  fi

  print_success "All dependencies satisfied"
}

run_module
