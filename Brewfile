# Use `brew bundle` to install the packages listed below

tap "atlassian/homebrew-acli"


# Command line tools, utilities and languages
brew "coreutils"
brew "findutils"

brew "git"
brew "git-filter-repo"
brew "bash"
brew "curl"
brew "direnv"
brew "grep"
brew "gpg"
brew "gawk"
brew "less"
brew "tree"
brew "vim"
brew "wget"
brew "whois"

brew "gzip"
brew "unzip"

brew "md5sha1sum"
brew "openssl"
brew "ssh-copy-id"
brew "rsync"

brew "libpq" # postgres c-api

brew "jq"
brew "gh"

brew "go-task"

# asdf runtime version manager
# @see https://asdf-vm.com/guide/getting-started.html
brew "asdf", postinstall: "${HOMEBREW_PREFIX}/bin/asdf plugin add dotnet && ${HOMEBREW_PREFIX}/bin/asdf plugin add nodejs && ${HOMEBREW_PREFIX}/bin/asdf plugin add python"

# System runtimes (for asdf fallbacks and other tool dependencies)
#cask "dotnet-sdk"
#brew "node"
#brew "python3"

# ZSH Plugins and shell
brew "zsh"
brew "zsh-completions"
brew "zsh-autosuggestions"
brew "zsh-syntax-highlighting"

brew "starship", postinstall: "${HOMEBREW_PREFIX}/bin/starship preset nerd-font-symbols -o ~/.config/starship.toml"

# Containerization
brew "kubernetes-cli"
#cask "docker"
#cask "podman-desktop"

# Devops
brew "terraform"
brew "terragrunt"

# Apps

cask "acli"
cask "brave-browser"
cask "claude"
cask "discord"
cask "ghostty", postinstall: "mkdir -p ${HOME}/.config/ghostty && ln -s ./config/ghostty/config ${HOME}/.config/ghostty/config"
#cask "ngrok"
cask "notion"
cask "postman"
cask "raycast"
cask "spotify"
cask "the-unarchiver"

cask "mongodb-compass"

cask "datagrip"
cask "rider"
cask "webstorm"
cask "visual-studio-code"

# Fonts
cask "font-source-code-pro"
cask "font-source-code-pro-for-powerline"
cask "font-fira-code"
cask "font-fira-mono"
cask "font-fira-code-nerd-font"

# Appstore apps
#mas "1Password", id: 443987910
