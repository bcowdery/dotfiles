# Use `brew bundle` to install the packages listed below
# Run `brew bundle` from the directory containing this file

# =============================================================================
# System & Shell
# =============================================================================

# Core utilities
brew "coreutils"
brew "findutils"
brew "gawk"
brew "grep"
brew "less"
brew "tree"
brew "lsd"

# Compression & archives
brew "gzip"
brew "unzip"

# Security & encryption
brew "gpg"
brew "openssl"
brew "md5sha1sum"

# Shell tools
brew "bash"
brew "zsh"
brew "zsh-completions"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"
brew "starship", postinstall: "${HOMEBREW_PREFIX}/bin/starship preset nerd-font-symbols -o ~/.config/starship.toml"
brew "direnv"
brew "zoxide"
brew "screen"

cask "ghostty", postinstall: "mkdir -p ${HOME}/.config/ghostty && ln -s ./config/ghostty/config ${HOME}/.config/ghostty/config"

# Network tools
brew "curl"
brew "wget"
brew "whois"
brew "rsync"
brew "ssh-copy-id"
brew "tcpdump"
#cask "ngrok"

# =============================================================================
# Development
# =============================================================================

# Editors & IDEs
brew "vim"
cask "datagrip"
cask "rider"
cask "webstorm"
cask "visual-studio-code"

# Version control
brew "git"
brew "git-filter-repo"
brew "git-flow"
brew "gh"

# Runtime management
brew "asdf", postinstall: "${HOMEBREW_PREFIX}/bin/asdf plugin add dotnet && ${HOMEBREW_PREFIX}/bin/asdf plugin add nodejs && ${HOMEBREW_PREFIX}/bin/asdf plugin add python"
brew "ruby"

# Data processing & code analysis
brew "jq"
brew "ast-grep"

# =============================================================================
# DevOps & Infrastructure
# =============================================================================

# Cloud & infrastructure
brew "awscli"
brew "terraform"
brew "terragrunt"
brew "kubernetes-cli"

# Build & task runners
brew "act"
brew "go-task"

# Containers
cask "docker-desktop"

# Database tools
brew "libpq"  # PostgreSQL C API, needed for some python libs like psycopg2
cask "postman"
cask "mongodb-compass"

# =============================================================================
# Productivity & Apps
# =============================================================================

# Productivity
cask "claude"
cask "notion"
cask "raycast"

# Browser
cask "brave-browser"

# Compression & archives
cask "the-unarchiver"

# Communication & media
cask "discord"
cask "spotify"

# Mouse & Keyboard
cask "logi-options+"

# Password management
cask "1password-cli"

# =============================================================================
# Fonts
# =============================================================================

cask "font-fira-code"
cask "font-fira-code-nerd-font"
cask "font-fira-mono"
cask "font-source-code-pro"
cask "font-source-code-pro-for-powerline"

# =============================================================================
# Mac App Store
# =============================================================================

brew "mas"    # Mac App Store CLI

#mas "1Password", id: 443987910
