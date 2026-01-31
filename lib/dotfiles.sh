#!/usr/bin/env bash

# The rsync command
function rsync_dotfiles()
{
    rsync --exclude "init/" \
        --exclude "bin/" \
        --exclude "lib/" \
        --exclude "config/" \
        --exclude ".extra" \
        --exclude ".git/" \
        --exclude ".gitignore" \
        --exclude ".editorconfig" \
        --exclude ".claude/" \
        --exclude "bootstrap.sh" \
        --exclude "Brewfile" \
        --exclude "macos.sh" \
        --exclude "Readme.md" \
        -avh --no-perms --quiet . ~;
}

# Symlink config files to ~/.config
function symlink_configs()
{
    echo "🔗 ${bold}Symlinking config files...${reset}"

    # Starship prompt configuration
    mkdir -p ~/.config
    if [ -f ./config/starship.toml ]; then
        ln -sf "$PWD/config/starship.toml" ~/.config/starship.toml
        echo "   starship.toml → ~/.config/starship.toml"
    fi
}

# Copies dotfiles to the home directory, with an option to force overwrite.
# Accepts an optional argument to force the copy without confirmation.
#
# If the --force or -f option is provided, copy the dotfiles without prompting.
#
# Note: .extra is only copied if it doesn't exist (never overwrites user customizations)
#
function update_dotfiles()
{
    echo
    echo "🖥️ ${bold}Copying dotfiles to home directory...${reset}"

    if [ "$1" == "--force" -o "$1" == "-f" ]; then
        # Only copy .extra template if it doesn't already exist (preserve user customizations)
        if [ ! -f ~/.extra ]; then
            cp .extra ~/.extra
            echo "   Created ~/.extra (customize this file for machine-specific settings)"
        fi
        rsync_dotfiles
        symlink_configs

    else
        echo "${italic}This will overwrite existing files in your home directory.${reset}"
        read -p "${italic}Are you sure? (y/N) ${reset}" yn;

        case $yn in
            [Yy]* )
                rsync_dotfiles
                symlink_configs
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
