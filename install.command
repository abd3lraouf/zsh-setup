#!/bin/zsh

# ZSH Setup Script - Main Installer
# Auto-discovers and runs modular installation scripts

set -e

# Setup directories
export SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
export RESOURCES_DIR="$SCRIPT_DIR/resources"
export LIB_DIR="$SCRIPT_DIR/lib"
export MODULES_DIR="$SCRIPT_DIR/modules"

# Source common functions
source "$LIB_DIR/common.sh"

echo "========================================"
echo "  ZSH Setup Script"
echo "========================================"
echo ""

# Check if resources exist
if [[ ! -d "$RESOURCES_DIR" ]]; then
  print_error "Error: resources folder not found at $RESOURCES_DIR"
  exit 1
fi

# Check if modules exist
if [[ ! -d "$MODULES_DIR" ]]; then
  print_error "Error: modules folder not found at $MODULES_DIR"
  exit 1
fi

# Auto-discover modules (sorted numerically)
MODULES=($(ls -1 "$MODULES_DIR"/*.sh 2>/dev/null | sort -V))

if [[ ${#MODULES[@]} -eq 0 ]]; then
  print_error "Error: No modules found in $MODULES_DIR"
  exit 1
fi

TOTAL_MODULES=${#MODULES[@]}

echo "Found $TOTAL_MODULES modules to run"
echo ""

# Track selected plugins across modules
export SELECTED_PLUGINS=""

# Track installed components for summary
export INSTALLED_ITEMS=""
export SKIPPED_ITEMS=""

# Helper to track installations
track_installed() {
  if [[ -n "$INSTALLED_ITEMS" ]]; then
    INSTALLED_ITEMS="${INSTALLED_ITEMS}|$1"
  else
    INSTALLED_ITEMS="$1"
  fi
}

track_skipped() {
  if [[ -n "$SKIPPED_ITEMS" ]]; then
    SKIPPED_ITEMS="${SKIPPED_ITEMS}|$1"
  else
    SKIPPED_ITEMS="$1"
  fi
}

# Run each module
CURRENT=0
for module in "${MODULES[@]}"; do
  CURRENT=$((CURRENT + 1))

  # Print step number prefix
  echo -n "[$CURRENT/$TOTAL_MODULES] "

  # Source the module (runs in same shell to share variables)
  source "$module"

  echo ""
done

# ----------------------------------------
# Installation Summary
# ----------------------------------------
echo "========================================"
echo "  ${GREEN}Setup Complete!${NC}"
echo "========================================"
echo ""

# Show installed items
if [[ -n "$INSTALLED_ITEMS" ]]; then
  echo "${GREEN}Installed:${NC}"
  echo "$INSTALLED_ITEMS" | tr '|' '\n' | while read item; do
    echo "  ✓ $item"
  done
  echo ""
fi

# Show skipped items
if [[ -n "$SKIPPED_ITEMS" ]]; then
  echo "${YELLOW}Skipped:${NC}"
  echo "$SKIPPED_ITEMS" | tr '|' '\n' | while read item; do
    echo "  - $item"
  done
  echo ""
fi

# Show plugins
if [[ -n "$SELECTED_PLUGINS" ]]; then
  PLUGIN_LIST=$(echo "$SELECTED_PLUGINS" | tr '|' ' ')
  echo "${CYAN}Plugins:${NC} git $PLUGIN_LIST"
  echo ""
fi

echo "----------------------------------------"
echo ""
echo "${BOLD}Next Steps:${NC}"
echo ""
echo "1. Set terminal font to ${CYAN}MesloLGS NF${NC}:"
echo "   - iTerm2: Preferences → Profiles → Text → Font"
echo "   - Terminal.app: Preferences → Profiles → Font"
echo "   - VS Code: \"terminal.integrated.fontFamily\": \"MesloLGS NF\""
echo "   - Warp: Settings → Appearance → Terminal font"
echo ""
echo "2. Restart your terminal or run:"
echo "   ${CYAN}exec zsh${NC}"
echo ""
echo "3. Configure Powerlevel10k (if needed):"
echo "   ${CYAN}p10k configure${NC}"
echo ""
echo "========================================"
