#!/usr/bin/env bash

# Installs Homebrew if it is not already installed.
# If Homebrew is installed, it will do nothing.
#
function install_homebrew()
{
    echo
    echo "📦 ${bold}Installing Homebrew...${reset}"

    if ! command -v brew > /dev/null 2>&1; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    if ! command -v brew > /dev/null 2>&1; then
        echo "${red}${bold} Error: installation failed.${reset}"
        exit;
    fi

    echo
    echo "✅ ${green}Done.${reset}"
}

# Updates Homebrew and all installed packages, then cleans up.
# This will:
#   - Update Homebrew itself and package definitions
#   - Upgrade all installed formulae and casks
#   - Install any new packages from the Brewfile
#   - Remove outdated versions and cached downloads
#
function update_brewfile()
{
    echo
    echo "📦 ${bold}Updating Homebrew and installed packages...${reset}"

    brew update
    brew upgrade
    brew upgrade --cask --greedy
    brew bundle
    brew cleanup --prune=all

    echo
    echo "✅ ${green}Done.${reset}"
}

# Lists installed packages that are NOT in the Brewfile.
# Use this to identify manually installed packages that should
# either be added to the Brewfile or removed.
#
function brewfile_orphans()
{
    echo
    echo "🔍 ${bold}Packages not listed in Brewfile:${reset}"
    echo

    brew bundle cleanup

    echo
    echo "💡 Run ${bold}brew bundle cleanup --force${reset} to remove these packages."
}
