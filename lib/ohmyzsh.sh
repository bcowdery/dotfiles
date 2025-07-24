#!/usr/bin/env bash

# Installs Oh My Zsh if it is not already installed.
# If Oh My Zsh is installed, it will do nothing.
#
function install_ohmyzsh() {
    printf "$yellow\n" "Installing Oh My Zsh... "

    if [ ! -d ~/.oh-my-zsh ]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    if [ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]; then
        printf "$red\n" "Failed ✗";
        exit;
    fi

    printf "$green\n" "Ok ✓"
}
