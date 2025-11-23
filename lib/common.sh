#!/bin/zsh

# Common functions and variables for ZSH setup scripts

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export CYAN='\033[0;36m'
export MAGENTA='\033[0;35m'
export BOLD='\033[1m'
export DIM='\033[2m'
export NC='\033[0m' # No Color

# Spinner for long operations
spinner() {
  local pid=$1
  local message="${2:-Processing}"
  local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
  local i=0

  tput civis # Hide cursor
  while kill -0 $pid 2>/dev/null; do
    local char="${spinstr:$i:1}"
    printf "\r  ${CYAN}%s${NC} %s" "$char" "$message"
    i=$(( (i + 1) % ${#spinstr} ))
    sleep 0.1
  done
  tput cnorm # Show cursor
  printf "\r"
}

# Run command with spinner
run_with_spinner() {
  local message="$1"
  shift

  "$@" &>/dev/null &
  local pid=$!
  spinner $pid "$message"
  wait $pid
  return $?
}

# Check network connectivity
check_network() {
  if ! curl -s --head --connect-timeout 5 https://github.com &>/dev/null; then
    return 1
  fi
  return 0
}

# Print estimated time warning
print_time_estimate() {
  echo "  ${DIM}(This may take $1)${NC}"
}

# Script directories
export SCRIPT_DIR="${SCRIPT_DIR:-$(cd "$(dirname "$0")" && pwd)}"
export RESOURCES_DIR="${SCRIPT_DIR}/resources"
export LIB_DIR="${SCRIPT_DIR}/lib"
export MODULES_DIR="${SCRIPT_DIR}/modules"

# Function to ask yes/no questions with arrow key toggle
ask() {
  local prompt="$1"
  local default="$2"
  local selected

  # Set initial selection based on default
  if [[ "$default" == "y" ]]; then
    selected=0  # Yes
  else
    selected=1  # No
  fi

  local key

  # Hide cursor
  tput civis

  # Draw function
  draw_ask() {
    local yes_display no_display
    if [[ $selected -eq 0 ]]; then
      yes_display="${GREEN}${BOLD}▸ Yes${NC}"
      no_display="  No"
    else
      yes_display="  Yes"
      no_display="${GREEN}${BOLD}▸ No${NC}"
    fi

    # Clear line and redraw
    if [[ $1 -eq 1 ]]; then
      printf "\r\033[K"
    fi
    printf "%s  %s  %s" "$prompt" "$yes_display" "$no_display"
  }

  # Initial draw
  draw_ask 0

  # Input loop
  while true; do
    read -sk1 key

    case "$key" in
      $'\x1b')  # Escape sequence
        read -sk2 key
        case "$key" in
          '[A'|'[D')  # Up or Left arrow
            selected=0
            ;;
          '[B'|'[C')  # Down or Right arrow
            selected=1
            ;;
        esac
        ;;
      'y'|'Y')
        selected=0
        ;;
      'n'|'N')
        selected=1
        ;;
      $'\n'|$'\r'|'')  # Enter
        break
        ;;
    esac

    draw_ask 1
  done

  # Show cursor and newline
  tput cnorm
  echo ""

  # Return result
  [[ $selected -eq 0 ]]
}

# Multiselect function
# Usage: multiselect result_var "option1|option2|option3" "preselected1|preselected2"
multiselect() {
  local result_var=$1
  local -a options
  local -a selected
  local -a defaults

  # Parse options
  IFS='|' read -A options <<< "$2"
  IFS='|' read -A defaults <<< "$3"

  # Initialize selection state
  local -a selection_state
  for i in {1..${#options[@]}}; do
    selection_state[$i]=0
  done

  # Set defaults
  for default in "${defaults[@]}"; do
    for i in {1..${#options[@]}}; do
      if [[ "${options[$i]}" == "$default"* ]]; then
        selection_state[$i]=1
      fi
    done
  done

  local cursor=1
  local key

  # Hide cursor
  tput civis

  # Draw menu
  draw_menu() {
    # Move cursor up to redraw
    if [[ $1 -eq 1 ]]; then
      for i in {1..${#options[@]}}; do
        tput cuu1
      done
      tput cuu1
      tput cuu1
    fi

    echo "  ${CYAN}↑/↓ move, SPACE toggle, a=all, n=none, ENTER confirm${NC}"
    echo ""

    for i in {1..${#options[@]}}; do
      local prefix="  "
      local marker="[ ]"

      if [[ $i -eq $cursor ]]; then
        prefix="> "
      fi

      if [[ ${selection_state[$i]} -eq 1 ]]; then
        marker="[${GREEN}x${NC}]"
      fi

      echo "${prefix}${marker} ${options[$i]}"
    done
  }

  # Initial draw
  draw_menu 0

  # Input loop
  while true; do
    # Read single character
    read -sk1 key

    case "$key" in
      $'\x1b')  # Escape sequence
        read -sk2 key
        case "$key" in
          '[A')  # Up arrow
            ((cursor--))
            [[ $cursor -lt 1 ]] && cursor=${#options[@]}
            ;;
          '[B')  # Down arrow
            ((cursor++))
            [[ $cursor -gt ${#options[@]} ]] && cursor=1
            ;;
        esac
        ;;
      ' ')  # Space - toggle
        if [[ ${selection_state[$cursor]} -eq 1 ]]; then
          selection_state[$cursor]=0
        else
          selection_state[$cursor]=1
        fi
        ;;
      'a'|'A')  # Select all
        for i in {1..${#options[@]}}; do
          selection_state[$i]=1
        done
        ;;
      'n'|'N')  # Select none
        for i in {1..${#options[@]}}; do
          selection_state[$i]=0
        done
        ;;
      $'\n'|$'\r'|'')  # Enter - confirm (newline, carriage return, or empty)
        break
        ;;
    esac

    draw_menu 1
  done

  # Show cursor
  tput cnorm
  echo ""

  # Build result
  local result=""
  for i in {1..${#options[@]}}; do
    if [[ ${selection_state[$i]} -eq 1 ]]; then
      # Extract plugin name (first word)
      local plugin_name=$(echo "${options[$i]}" | awk '{print $1}')
      if [[ -n "$result" ]]; then
        result="${result}|${plugin_name}"
      else
        result="${plugin_name}"
      fi
    fi
  done

  eval "$result_var='$result'"
}

# Function to print step header
print_step() {
  local current=$1
  local total=$2
  local message=$3
  echo "[$current/$total] $message"
}

# Function to print success message
print_success() {
  echo "  ${GREEN}$1${NC}"
}

# Function to print warning message
print_warning() {
  echo "  ${YELLOW}$1${NC}"
}

# Function to print error message
print_error() {
  echo "  ${RED}$1${NC}"
}

# Function to print info message
print_info() {
  echo "  $1"
}
