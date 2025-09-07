#!/usr/bin/env bash

# Installs Homebrew if it is not already installed.
# If Homebrew is installed, it will do nothing.
#
function install_homebrew()
{
    echo
    echo "📦 ${bold}Installing Homebrew...${reset}"

    if [ ! which brew > /dev/null 2>&1 ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if [ ! which brew > /dev/null 2>&1 ]; then
        echo "${red}${bold} Error: installation failed.${reset}"
        exit;
    fi

    echo
    echo "✅ ${green}Done.${reset}"
}

# Installs all apps listed in the Brewfile.
# This function updates Homebrew, installs the apps, and cleans up.
#
function update_brewfile()
{
    echo
    echo "📦 ${bold}Installing all apps listed in Brewfile...${reset}"

    brew update
    brew bundle
    brew cleanup

    echo
    echo "✅ ${green}Done.${reset}"
}
