#!/usr/bin/env bash


ASDF_PYTHON_VERSION="latest:3"
ASDF_NODE_VERSION="latest:22"
ASDF_DOTNET_VERSION="latest:9"

# Updates ASDF plugins and installs the latest versions of each language.
#
function update_asdf()
{
    echo
    echo "👾 ${bold}Updating ASDF plugins and installing latest versions...${reset}"

    asdf plugin update --all

    # Install the latest versions of each language and set as the default
    asdf install dotnet "$ASDF_DOTNET_VERSION"
    asdf set --home dotnet "$ASDF_DOTNET_VERSION" system

    asdf install nodejs "$ASDF_NODE_VERSION"
    asdf set --home nodejs "$ASDF_NODE_VERSION" system

    asdf install python "$ASDF_PYTHON_VERSION"
    asdf set --home python "$ASDF_PYTHON_VERSION" system

    echo
    echo "✅ ${green}Done.${reset}"
}

# Installs the latest LST releases of NodeJS and Python and creates
# the default ~/.tool-version file in your home directory, with a
# fallback to the OS installed 'system' version.
#
function configure_asdf()
{
    echo
    echo "👾 ${bold}Configuring ASDF defaults and installing latest versions...${reset}"

    # Install the latest dotnet SDK and set as the default
    asdf plugin add dotnet
    asdf install dotnet "$ASDF_DOTNET_VERSION"
    asdf set --home dotnet "$ASDF_DOTNET_VERSION" system

    # Install the latest nodejs v22 LTS and set as the default
    asdf plugin add nodejs
    asdf install nodejs "$ASDF_NODE_VERSION"
    asdf set --home nodejs "$ASDF_NODE_VERSION" system

    # Install the latest python3 and set as the default
    asdf plugin add python
    asdf install python "$ASDF_PYTHON_VERSION"
    asdf set --home python "$ASDF_PYTHON_VERSION" system

    echo
    echo "✅ ${green}Done.${reset}"
}
