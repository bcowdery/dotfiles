#!/usr/bin/env bash
#
# Bootstrap script to install and configure a new macOS system.
#
# This script can be run at any time to install and configure the system. Be aware that dotfiles
# in your $HOME directory will be overwritten if they exist.
#

# highlighting colours
red='\e[1;31m%s\e[0m'
green='\e[1;32m%s\e[0m'
yellow='\e[1;33m%s\e[0m'

# this script name
SCRIPT_NAME="$(basename "$0")"

# this script can be run from anywhere,
# Follow the symlink to the directory where the actual script is located
if [ -L "$0" ]; then
    BOOTSTRAP_DIR="$(cd "$(dirname "$(readlink "$0")")" && pwd)"
else
    BOOTSTRAP_DIR="$(cd "$(dirname "$0")" && pwd)"
fi

cd "$BOOTSTRAP_DIR" || exit 1

# source all modules in `lib`
for f in ./lib/*.sh; do source "$f"; done;

# Show help message
#
# Accepts no arguments.
#
function show_help() {
    echo "Usage: $(basename $0) <command> [options]"
    echo ""
    echo "Available commands:"
    echo "  install   - Install all installers, apps, and copy dotfiles to the home directory."
    echo "  update    - Update all installed apps, and copy dotfiles to the home directory and create symlinks for user scripts."
    echo "  configure - Configure defaults for installed tools and language managers."
    echo "  edit      - Edit a file or installer manifest using the \$EDITOR"
    echo "  help      - Show this help message"
    echo ""
    echo "Options: "
    echo "  Use 'edit homebrew' to edit the Brewfile."
    echo "  Use 'update homebrew' or 'update dotfiles' to run a specific installer."
    echo "  Use 'update scripts' to symling scripts to ~/.local/bin."
    echo "  Use 'configure asdf' to set up default language versions."
}

# Edit a file using the configured EDITOR (default to vim).
#
# Accepts a filename as an argument, or the 'homebrew' keyword to edit the
# installer file. If no argument is provided, the entire current directory
# will be opened in the editor.
#
# @param $1 filename - the filename to edit
#
function edit_command() {
    local filename="$1"

    # check if the filename is 'homebrew'
    # default to the current directory if not set
    if [ -z "$filename" ]; then
        filename="."
    elif [ "$filename" == "homebrew" ]; then
        filename="Brewfile"
    fi

    # edit the file using configured EDITOR
    # default to vim if not set
    if [ -n "$EDITOR" ]; then
        $EDITOR "$filename"
    else
        vim "$filename"
    fi
}

# Update installers, apps, and dotfiles.
#
# Accepts an installer as an argument, either 'homebrew', 'dotfiles' or 'scripts'.
# If no argument is provided, all installers will be updated.
#
# @param $1 installer - the installer to update
#
function update_command() {
    local installer="$1"

    if [ -z "$installer" ]; then
        # run all installerss
        update_brewfile
        update_dotfiles
        update_scripts

    else
        # run only the specified installer
        case "$installer" in
            "homebrew") update_brewfile ;;
            "dotfiles") update_dotfiles ;;
            "scripts")  update_scripts  ;;
            *) printf "$red\n" "Unknown installer '$installer'".
        esac
    fi
}

# Install all apps, copies dotfiles to the home directory, and configures
# the ZSH shell and commandline environment to my liking. Typically used
# to setup a new MacOS environment.
#
# Accepts no arguments.
#
function install_command()
{
    # symlink the bootstrap script to ~/.local/bin/bootstrap
    install_bootstrap_script

    # run installers
    install_ohmyzsh
    install_homebrew

    # update dotfiles and homebrew apps
    update_dotfiles --force
    update_brewfile
    update_scripts
}

# Configures a tool using some out of box defaults
#
# param $1 - Name of the tool to configure (e.g., asdf)
#
function configure_command()
{
    local tool="$1"

    if [ -z "$tool" ]; then
        # connfigure all tools
        configure_asdf

    else
        # configure only the specified tool
        case "$1" in
            "asdf") configure_asdf;;
            *     ) printf "$red\n" "Unknown tool '$tool'";;
        esac
    fi
}

# Run the command
case "$1" in
    "install")
        install_command
        ;;
    "edit")
        edit_command "${@:2}"
        ;;
    "update")
        update_command "${@:2}"
        ;;
    "configure")
        configure_command "${@:2}"
        ;;
    "help"|"")
        show_help
        ;;
    *)
        echo "Error: Unknown command '$1'"
        show_help
        exit 1
        ;;
esac
