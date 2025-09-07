#!/usr/bin/env bash

function update_ohmyzsh()
{
    echo
    echo "⌨️ ${bold}Updating Oh My Zsh...${reset}"

    $ZSH/tools/upgrade.sh

    echo
    echo "✅ ${green}Done.${reset}"
}

# Installs Oh My Zsh if it is not already installed.
# If Oh My Zsh is installed, it will do nothing.
#
function install_ohmyzsh() {

    echo
    echo "⌨️ ${bold}Installing Oh My Zsh...${reset}"

    if [ ! -d ~/.oh-my-zsh ]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi

    if [ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]; then
        echo "${red}${bold} Error: installation failed.${reset}"
        exit;
    fi

    echo "✅ ${green}Ok.${reset}"
}
