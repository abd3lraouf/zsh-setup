#!/bin/zsh
# Module: Fonts
# Description: Install MesloLGS NF fonts for Powerlevel10k


run_module() {
  # Main script already printed step header
  echo "Installing MesloLGS NF fonts..."
  FONT_DIR="$HOME/Library/Fonts"
  BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"

  FONTS=(
    "MesloLGS%20NF%20Regular.ttf"
    "MesloLGS%20NF%20Bold.ttf"
    "MesloLGS%20NF%20Italic.ttf"
    "MesloLGS%20NF%20Bold%20Italic.ttf"
  )

  mkdir -p "$FONT_DIR"

  for font in "${FONTS[@]}"; do
    decoded_name=$(echo "$font" | sed 's/%20/ /g')
    if [[ -f "$FONT_DIR/$decoded_name" ]]; then
      echo "  $decoded_name already installed"
    else
      echo "  Downloading $decoded_name..."
      curl -fsSLo "$FONT_DIR/$decoded_name" "$BASE_URL/$font"
    fi
  done
  print_success "Fonts installed"
}

run_module
