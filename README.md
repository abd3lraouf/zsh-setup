# ZSH Setup

Interactive setup script for a complete ZSH development environment on macOS. Installs and configures Oh My Zsh, Powerlevel10k, development tools, and language runtimes with a single command.

- [Getting started](#getting-started)
- [Features](#features)
- [What gets installed](#what-gets-installed)
- [Requirements](#requirements)
- [Configuration](#configuration)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [License](#license)

## Getting started

1. Clone the repository:
   ```zsh
   git clone https://github.com/yourusername/zsh-setup.git
   cd zsh-setup
   ```

2. Run the installer:
   ```zsh
   ./install.command
   ```
   Or double-click `install.command` in Finder.

3. Follow the interactive prompts. Use arrow keys to navigate, SPACE to toggle options, ENTER to confirm.

4. Set your terminal font to `MesloLGS NF`:
   - **iTerm2**: Preferences → Profiles → Text → Font
   - **Terminal.app**: Preferences → Profiles → Font
   - **VS Code**: `"terminal.integrated.fontFamily": "MesloLGS NF"`
   - **Warp**: Settings → Appearance → Terminal font
   - **Ghostty**: Add `font-family = "MesloLGS NF"` to config

5. Restart your terminal or run `exec zsh`.

## Features

### Interactive installation

The installer guides you through each step with yes/no prompts and selection menus. Skip components you don't need, choose specific versions, and customize your setup without editing config files.

### Modular architecture

Each tool installs through an independent module. The installer auto-discovers modules in the `modules/` directory and runs them in sequence. Add, remove, or modify modules without touching the main script.

### Plugin selection

Choose from 20+ Oh My Zsh plugins through a multiselect menu:

```
  ↑/↓ move, SPACE toggle, a=all, n=none, ENTER confirm

  [x] zsh-autosuggestions      - Fish-like suggestions
  [x] zsh-syntax-highlighting  - Command syntax coloring
  [x] zsh-history-substring-search - Fish-like history search
  [x] zsh-completions          - Additional completions
  [x] you-should-use           - Alias reminders
  [x] zsh-bat                  - Use bat for cat/less
  [x] sudo                     - ESC twice to add sudo
  [x] copypath                 - Copy current path
  [x] copyfile                 - Copy file contents
> [x] extract                  - Extract any archive
  [x] web-search               - Search from terminal
  ...
```

Keyboard shortcuts:
- **a** - Select all plugins
- **n** - Deselect all plugins
- **SPACE** - Toggle current selection
- **ENTER** - Confirm and continue

Plugins already installed on your system are pre-selected.

### Automatic backups

Existing configuration files are backed up before modification:
- `~/.zshrc.backup.TIMESTAMP`
- `~/.zprofile.backup.TIMESTAMP`
- `~/.p10k.zsh.backup.TIMESTAMP`

### Git configuration

Set up git with your identity, recommended settings, and useful aliases:
- User name and email
- Default branch, pull rebase, auto-prune
- 15+ git aliases (`git s`, `git l`, `git cm`, etc.)

### Common aliases

Pre-configured shell aliases for productivity:
- Navigation: `..`, `...`, `~`, `-`
- Modern tools: `cat`→bat, `ls`→eza
- Git shortcuts: `g`, `gs`, `gd`, `gc`, `gp`, `gl`
- Utilities: `mkcd`, `ll`, `la`

### macOS defaults

Developer-friendly macOS settings:
- Show hidden files and extensions in Finder
- Fast key repeat rate
- Screenshots saved to ~/Screenshots
- Disable .DS_Store on network volumes

### Installation summary

At the end of installation, see a complete summary of what was installed and skipped.

## What gets installed

### CLI tools

| Tool | Description |
|------|-------------|
| [bat](https://github.com/sharkdp/bat) | `cat` with syntax highlighting and git integration |
| [fzf](https://github.com/junegunn/fzf) | Fuzzy finder for files, history, and more |
| [ripgrep](https://github.com/BurntSushi/ripgrep) | Fast recursive search |
| [eza](https://github.com/eza-community/eza) | Modern `ls` replacement |
| [zoxide](https://github.com/ajeetdsouza/zoxide) | Smart `cd` that learns your habits |
| [gh](https://cli.github.com/) | GitHub CLI |
| [issue2md](https://github.com/abd3lraouf/issue2md) | Convert GitHub issues to markdown |

### Languages and runtimes

| Runtime | Installation method | Notes |
|---------|---------------------|-------|
| Go | Homebrew | Latest stable version |
| Node.js | NVM | Version selectable during install |
| Python | pyenv | Version selectable, includes pipx |
| Ruby | rbenv | Installs CocoaPods gem |
| Java | SDKMAN | Version and vendor selectable, macOS integration |

### npm packages

- `typescript` - TypeScript compiler
- `prettier` - Code formatter
- `eslint` - JavaScript linter
- `tldr` - Simplified man pages
- `@anthropic-ai/claude-code` - Claude CLI

### ZSH components

- **Oh My Zsh** - Framework for managing ZSH configuration
- **Powerlevel10k** - Fast, customizable prompt theme
- **MesloLGS NF** - Nerd Font with all required glyphs

### Plugins available

| Plugin | Description |
|--------|-------------|
| zsh-autosuggestions | Fish-like command suggestions |
| zsh-syntax-highlighting | Command syntax coloring |
| zsh-history-substring-search | Fish-like history search |
| zsh-completions | Additional completion definitions |
| you-should-use | Reminds you of existing aliases |
| zsh-bat | Use bat for cat/less with syntax highlighting |
| sudo | Press ESC twice to prefix command with sudo |
| copypath | Copy current directory path to clipboard |
| copyfile | Copy file contents to clipboard |
| extract | Extract any archive format |
| web-search | Search Google, GitHub, etc. from terminal |
| jsontools | `pp_json`, `is_json`, `urlencode`, `urldecode` |
| docker | Docker completions and aliases |
| docker-compose | Docker Compose completions |
| npm | npm completions and aliases |
| kubectl | Kubernetes CLI completions |
| aws | AWS CLI completions |
| macos | macOS utilities (`showfiles`, `hidefiles`, etc.) |
| git | 100+ git aliases and functions |
| fzf | Fuzzy finder integration |

## Requirements

- macOS (tested on Sonoma)
- Internet connection for downloading packages
- Administrator access for some installations

## Configuration

After installation, your shell reads configuration from these files:

| File | Purpose |
|------|---------|
| `~/.zshrc` | Main shell configuration, plugins, aliases |
| `~/.zprofile` | Login shell configuration, environment variables |
| `~/.p10k.zsh` | Powerlevel10k prompt configuration |

### Reconfiguring the prompt

Run `p10k configure` to launch the Powerlevel10k configuration wizard.

### Environment variables

The installer adds these to `~/.zprofile`:

```zsh
# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
```

### GitHub token

For the `ghissue2md` function, add to `~/.zprofile`:

```zsh
export GITHUB_TOKEN="your_token_here"
```

Create a token at https://github.com/settings/tokens with `repo` and `read:user` scopes.

## Customization

### Adding modules

Create a new file in `modules/` with a numeric prefix:

```zsh
#!/bin/zsh
# Module: My Tool
# Description: Install my tool

run_module() {
  echo "My Tool..."

  if command -v mytool &>/dev/null; then
    print_success "mytool already installed"
  else
    if ask "  Install mytool?" "y"; then
      brew install mytool
      print_success "mytool installed"
    else
      print_warning "Skipping mytool"
    fi
  fi
}

run_module
```

Make it executable:

```zsh
chmod +x modules/18-mytool.sh
```

The installer auto-discovers and runs all `.sh` files in `modules/`, sorted by filename.

### Modifying plugins

Edit `modules/14-plugins.sh`:

- `PLUGIN_OPTIONS` - Available plugins in the selection menu
- `DEFAULT_PLUGINS` - Pre-selected plugins for new installations

### Project structure

```
zsh-setup/
├── install.command          # Main entry point
├── lib/
│   └── common.sh            # Shared functions
├── modules/
│   ├── 01-dependencies.sh   # Verify git, curl
│   ├── 02-shell.sh          # Set ZSH as default
│   ├── 03-homebrew.sh       # Install Homebrew
│   ├── 04-tools.sh          # CLI tools
│   ├── 05-go.sh             # Go language
│   ├── 06-issue2md.sh       # GitHub issue converter
│   ├── 07-nvm.sh            # Node Version Manager
│   ├── 08-node.sh           # Node.js
│   ├── 09-npm-packages.sh   # Global npm packages
│   ├── 10-ruby.sh           # Ruby via rbenv
│   ├── 11-sdkman.sh         # SDKMAN and Java
│   ├── 12-ohmyzsh.sh        # Oh My Zsh
│   ├── 13-powerlevel10k.sh  # Prompt theme
│   ├── 14-plugins.sh        # ZSH plugins
│   ├── 15-fonts.sh          # MesloLGS NF
│   ├── 16-config.sh         # Shell configs
│   ├── 17-github-token.sh   # GitHub token setup
│   ├── 18-git-config.sh     # Git user and settings
│   ├── 19-python.sh         # Python via pyenv
│   └── 20-macos-defaults.sh # macOS developer settings
└── resources/
    ├── .p10k.zsh            # Prompt config
    └── .zprofile            # Profile template
```

## Troubleshooting

### Fonts not rendering correctly

Symptoms: Question marks, boxes, or missing icons in prompt.

1. Verify fonts are installed:
   ```zsh
   ls ~/Library/Fonts/MesloLGS*
   ```
2. Set terminal font to "MesloLGS NF" (not "Meslo" or other variants)
3. Restart terminal completely (not just new tab)
4. Run `p10k configure` if issues persist

### Plugins not loading

1. Check plugin list in `~/.zshrc`:
   ```zsh
   grep "^plugins=" ~/.zshrc
   ```
2. Verify directories exist:
   ```zsh
   ls ~/.oh-my-zsh/custom/plugins/
   ```
3. Restart shell with `exec zsh` (not `source ~/.zshrc`)

### NVM command not found

Add to `~/.zshrc` after oh-my-zsh is sourced:

```zsh
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
```

### SDKMAN command not found

```zsh
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
```

### Slow shell startup

1. Disable unused plugins in `~/.zshrc`
2. Enable Powerlevel10k instant prompt (enabled by default)
3. Profile startup time:
   ```zsh
   time zsh -i -c exit
   ```

### Wrong colors or symbols

1. Verify `TERM` is set correctly:
   ```zsh
   echo $TERM
   ```
   Should be `xterm-256color` or similar.

2. Reconfigure prompt:
   ```zsh
   p10k configure
   ```

## Functions

### ghissue2md

Convert GitHub issues to markdown and copy to clipboard:

```zsh
ghissue2md https://github.com/owner/repo/issues/123
```

Requires `GITHUB_TOKEN` with `repo` and `read:user` scopes.

## Updating

To update individual components:

| Component | Update command |
|-----------|----------------|
| Oh My Zsh | `omz update` |
| Powerlevel10k | `git -C ~/.oh-my-zsh/custom/themes/powerlevel10k pull` |
| Homebrew packages | `brew update && brew upgrade` |
| npm packages | `npm update -g` |
| SDKMAN | `sdk selfupdate` |

## Uninstalling

To restore your previous shell configuration:

1. Restore backup files:
   ```zsh
   cp ~/.zshrc.backup.* ~/.zshrc
   cp ~/.zprofile.backup.* ~/.zprofile
   ```

2. Change default shell:
   ```zsh
   chsh -s /bin/bash
   ```

3. Remove installed components:
   ```zsh
   rm -rf ~/.oh-my-zsh
   rm -rf ~/.nvm
   rm -rf ~/.sdkman
   rm -rf ~/.rbenv
   ```

## License

MIT License - see [LICENSE](LICENSE) for details.

## Acknowledgments

- [Oh My Zsh](https://ohmyz.sh/)
- [Powerlevel10k](https://github.com/romkatv/powerlevel10k)
- [Homebrew](https://brew.sh/)
- [NVM](https://github.com/nvm-sh/nvm)
- [SDKMAN](https://sdkman.io/)
