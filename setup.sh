#!/bin/bash
red='\e[1;31m%s\e[0m'
green='\e[1;32m%s\e[0m'
yellow='\e[1;33m%s\e[0m'

cd "$(dirname "${BASH_SOURCE}")"

# get latest
git pull origin master &> /dev/null

# source all modules in `bin`
for f in ./bin/*.sh; do source "$f"; done;

# git'er done
install_ruby
install_homebrew

# Install Brefile
printf "Installing Brewfile... $yellow\n" "Working •"

brew update
brew tap caskroom/cask
brew bundle

# zsh
configure_zsh
configure_dotfiles
