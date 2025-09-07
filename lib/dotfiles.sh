#!/usr/bin/env bash

# The rsync command
function rsync_dotfiles()
{
    rsync --exclude "init/" \
        --exclude "bin/" \
        --exclude "lib/" \
        --exclude ".extra" \
        --exclude ".git/" \
        --exclude ".gitignore" \
        --exclude ".editorconfig" \
        --exclude "bootstrap.sh" \
        --exclude "Brewfile" \
        --exclude "macos.sh" \
        --exclude "Readme.md" \
        -avh --no-perms --quiet . ~;
}

# Copies dotfiles to the home directory, with an option to force overwrite.
# Accepts an optional argument to force the copy without confirmation.
#
# If the --force or -f option is provided, copy the dotfiles without prompting.
#
function update_dotfiles()
{
    echo
    echo "🖥️ ${bold}Copying dotfiles to home directory...${reset}"

    if [ "$1" == "--force" -o "$1" == "-f" ]; then
        cp .extra ~/.extra
        rsync_dotfiles

    else
        echo "${italic}This will overwrite existing files in your home directory.${reset}"
        read -p "${italic}Are you sure? (y/N) ${reset}" yn;

        case $yn in
            [Yy]* )
                rsync_dotfiles
                ;;
            * )
                echo "${yellow}Skipping dotfiles.${reset}"
                return
                ;;
        esac
    fi;

    echo
    echo "✅ ${green}Done.${reset}"
    echo "👉 ${green}Reload your shell or source ~/.zshrc to apply changes.${reset}"
}
