#!/usr/bin/env bash

LOCAL_BIN_DIR="$HOME/.local/bin"

function rsync_dotfiles() {
    echo "Syncing dotfiles..."

    # sync dotfiles
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

function symlink_scripts() {

    echo "Creating symlinks for scripts in $LOCAL_BIN_DIR... "

    # ensure the local script dir exists
    mkdir -p "$LOCAL_BIN_DIR";

    # symlink scripts to the ~/.local/bin directory
    # strip shell extensions from scripts for a more friendly user experience
    for f in ./bin/*.sh; do
        local script_path=$(realpath "$f");
        local script_name=$(basename "$f" .sh)
        ln -sf "$script_path" "$LOCAL_BIN_DIR/$script_name";
    done;

    # clean up broken symlinks
    echo "Looking for broken symlinks in $LOCAL_BIN_DIR..."
    find -L "$LOCAL_BIN_DIR" -type l -exec rm -i {} \;
}

function update_dotfiles() {
    printf "$yellow\n\n" "Copying dotfiles to home directory... "

    if [ "$1" == "--force" -o "$1" == "-f" ]; then
        cp .extra ~/.extra
        rsync_dotfiles
        symlink_scripts

    else
        echo "This will overwrite existing files in your home directory."
        read -p "Are you sure? (y/n) " yn;

        echo ""

        case $yn in
            [Yy]* )
                rsync_dotfiles
                symlink_scripts
            ;;
            * ) printf "Skiping dotfiles.\n\n"
        esac
    fi;

    printf "\n$green\n" "Done ✓"
    printf "$green\n\n" "Reload your shell or source ~/.zshrc to apply changes."
}
