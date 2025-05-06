#!/usr/bin/env bash

# Installs the latest LST releases of NodeJS and Python and creates
# the default ~/.tool-version file in your home directory, with a
# fallback to the OS installed 'system' version.
#
function configure_asdf()
{
	printf "$yellow\n" "Configuring ASDF defaults... "

	# Install the latest nodejs v22 LTS
	asdf plugin add nodejs
	asdf install nodejs latest:22
	asdf set --home nodejs latest:22 system

	# Install the latest python3
	asdf plugin add python
	asdf install python latest:3
	asdf set --home python latest:3 system

	printf "$green\n" "Done ✓"
}
