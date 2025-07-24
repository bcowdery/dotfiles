#!/usr/bin/env bash

# dir for custom user scripts
LOCAL_BIN_DIR="$HOME/.local/bin"

# Create symlinks for all scripts in the `bin` directory to
# the ~/.local/bin directory, so they can be run from anywhere.
#
# The scripts dir is added to the PATH in the .path config file.
#
function update_scripts()
{
    printf "$yellow\n" "Updating script symlinks in $LOCAL_BIN_DIR... "

    # ensure the local script dir exists
    mkdir -p "$LOCAL_BIN_DIR";

    # symlink scripts to the ~/.local/bin directory
    # strip shell extensions from scripts for a more friendly user experience
    for f in ./bin/*.sh; do
        local script_path=$(realpath "$f");
        local script_name=$(basename "$f" .sh)

        echo " • Linking $script_path → $LOCAL_BIN_DIR/$script_name"

        ln -sf "$script_path" "$LOCAL_BIN_DIR/$script_name";
    done;

    # remove any broken symlinks
    find -L "$LOCAL_BIN_DIR" -type l -exec rm -f {} \;

    printf "\n$green\n" "Done ✓"
}

# Installs the bootstrap script to ~/.local/bin/bootstrap
# This script is used to run the bootstrap process from anywhere.
#
function install_bootstrap_script()
{
    mkdir -p "$LOCAL_BIN_DIR"
    ln -sf "bootstrap.sh" "$LOCAL_BIN_DIR/bootstrap"
    export PATH="$LOCAL_BIN_DIR:$PATH"
}
