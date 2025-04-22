#!/bin/bash
red='\e[1;31m%s\e[0m'
green='\e[1;32m%s\e[0m'
yellow='\e[1;33m%s\e[0m'

# source all modules in `bin`
for f in ./bin/*.sh; do source "$f"; done;

# run installers
install_brewfile
configure_dotfiles

# make some empty dirs
mkdir -p ~/.nvm

# tada!
printf "$green\n" "All Done!"
