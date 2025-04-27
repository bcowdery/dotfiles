#!/usr/bin/env bash

function install_ohmyzsh() {
    printf "Installing Oh My Zsh... "

    if [ ! -d ~/.oh-my-zsh ]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    if [ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]; then
        printf "$red\n" "Failed ✗";
        exit;
    fi

    printf "$green\n" "Ok ✓"
}
