#!/usr/bin/env bash

# The rsync command for Claude config
function rsync_claude()
{
    rsync -avh --no-perms --quiet ./config/claude/ ~/.claude/;
}

# Copies Claude configuration to the home directory, with an option to force overwrite.
# Accepts an optional argument to force the copy without confirmation.
#
# If the --force or -f option is provided, copy the config without prompting.
#
function update_claude()
{
    echo
    echo "🤖 ${bold}Copying Claude configuration to ~/.claude...${reset}"

    if [ "$1" == "--force" -o "$1" == "-f" ]; then
        rsync_claude

    else
        echo "${italic}This will overwrite existing files in your ~/.claude directory.${reset}"
        read -p "${italic}Are you sure? (y/N) ${reset}" yn;

        case $yn in
            [Yy]* )
                rsync_claude
                ;;
            * )
                echo "${yellow}Skipping Claude configuration.${reset}"
                return
                ;;
        esac
    fi;

    echo
    echo "✅ ${green}Done.${reset}"
    echo "👉 ${green}Claude skills have been updated in ~/.claude${reset}"
}
