#!/usr/bin/env bash

# dir for custom user scripts
LOCAL_BIN_DIR="$HOME/.local/bin"

create_symlinks()
{
    # ensure the local script dir exists
    mkdir -p "$LOCAL_BIN_DIR";

    # symlink scripts to the ~/.local/bin directory
    # strip shell extensions from scripts for a more friendly user experience
    echo
    echo "Linking:"

    for f in ./bin/*.sh; do
        local script_path=$(realpath "$f");
        local script_name=$(basename "$f" .sh)

        echo " • $script_path → $LOCAL_BIN_DIR/$script_name"

        ln -sf "$script_path" "$LOCAL_BIN_DIR/$script_name";
    done;

    # remove any broken symlinks
    find -L "$LOCAL_BIN_DIR" -type l -exec rm -f {} \;
}

# Create symlinks for all scripts in the `bin` directory to
# the ~/.local/bin directory, so they can be run from anywhere.
#
# The scripts dir is added to the PATH in the .path config file.
#
# If the --force or -f option is provided, create symlinks without prompting.
#
function update_scripts()
{
    echo
    echo "🔗 ${bold}Updating script symlinks in $LOCAL_BIN_DIR...${reset}"

    if [ "$1" == "--force" -o "$1" == "-f" ]; then
        create_symlinks

    else
        echo "${italic}This will replace any existing symlinks in ~/.local/bin and remove broken ones.${reset}"
        read -p "${italic}Are you sure? (y/N) ${reset}" yn;

        case $yn in
            [Yy]* )
                create_symlinks
                ;;
            * )
                echo "${yellow}Skipping script symlinks.${reset}"
                return
                ;;
        esac
    fi;

    echo
    echo "✅ ${green}Done.${reset}"
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
