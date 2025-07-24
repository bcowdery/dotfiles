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
        --exclude "bootstrap.sh" \
        --exclude "Brewfile" \
        --exclude "macos.sh" \
        --exclude "Readme.md" \
        -avh --no-perms --quiet . ~;
}

# Copies dotfiles to the home directory, with an option to force overwrite.
# Accepts an optional argument to force the copy without confirmation.
#
# If the --force or -f option is provided, it will copy the dotfiles without prompting.
#
function update_dotfiles()
{
    printf "$yellow\n\n" "Copying dotfiles to home directory... "

    if [ "$1" == "--force" -o "$1" == "-f" ]; then
        cp .extra ~/.extra
        rsync_dotfiles

    else
        echo "This will overwrite existing files in your home directory."
        read -p "Are you sure? (y/n) " yn;

        echo ""

        case $yn in
            [Yy]* )
                rsync_dotfiles
            ;;
            * ) printf "Skiping dotfiles.\n\n"
        esac
    fi;

    printf "\n$green\n" "Done ✓"
    printf "$green\n\n" "Reload your shell or source ~/.zshrc to apply changes."
}
