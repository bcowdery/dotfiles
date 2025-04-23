#!/usr/bin/env bash

NVM_VERSION="0.40.2"
NVM_DIR="$HOME/.nvm"

function install_nvm() {
	if [ ! -f "$HOME/.nvm/nvm.sh" ]; then
		printf "$yellow\n" "Installing NVM... "

		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh | bash

		export NVM_DIR="$NVM_DIR"
		source "$NVM_DIR/nvm.sh" && \. "$NVM_DIR/nvm.sh"

	else
		printf "$yellow\n" "Updating NVM... "

		(
			cd "$NVM_DIR"
			git fetch --tags origin
			git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
		) && \. "$NVM_DIR/nvm.sh"
	fi

	if [ ! -f "$NVM_DIR/nvm.sh" ]; then
		printf "$red\n\n" "Failed ✗";
		exit;
	fi

	printf "$green\n\n" "Done ✓";
}

function install_node() {
  printf "$yellow\n" "Installing Node.js... "

  if [ ! -f "$HOME/.nvm/nvm.sh" ]; then
      printf "$red\n\n" "Failed (nvm not installed) ✗";
      exit;
  fi

  if [ ! which node > /dev/null 2>&1 ]; then
      source "$NVM_DIR/nvm.sh" && nvm install --lts
  fi

  if [ ! which node > /dev/null 2>&1 ]; then
      printf "$red\n\n" "Failed ✗";
      exit;
  fi

  printf "$green\n\n" "Done ✓";
}
