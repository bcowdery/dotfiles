#!/usr/bin/env bash

# Installs Homebrew if it is not already installed.
# If Homebrew is installed, it will do nothing.
#
function install_homebrew()
{
    printf  "$yellow\n" "Installing Homebrew... "

    if [ ! which brew > /dev/null 2>&1 ]; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if [ ! which brew > /dev/null 2>&1 ]; then
        printf "$red\n\n" "Failed ✗";
        exit;
    fi

    printf "$green\n\n" "Done ✓"
}

# Installs all apps listed in the Brewfile.
# This function updates Homebrew, installs the apps, and cleans up.
#
function update_brewfile()
{
    printf "$yellow\n" "Installing all apps listed in Brewfile..."

    brew update
    brew bundle
    brew cleanup

    printf "$green\n\n" "Done ✓"
}
