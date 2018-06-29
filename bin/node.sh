#!/bin/bash

NVM_VERSION="0.33.11"
NVM_DIR="$HOME/.nvm"

function install_nvm() {
  if [ ! -f "$HOME/.nvm/nvm.sh" ]; then
		printf "Installing NVM ..."

    curl -sSL https://raw.githubusercontent.com/creationix/nvm/v$(NVM_VERSION)/install.sh | bash
    export NVM_DIR="$NVM_DIR"
    source "$NVM_DIR/nvm.sh" && \. "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/bash_completion" && \. "$NVM_DIR/bash_completion"
	else 
		printf "$yellow\n" "Updating NVM ..."

		(
		  cd "$NVM_DIR"
		  git fetch --tags origin
  		git checkout `git describe --abbrev=0 --tags --match "v[0-9]*" $(git rev-list --tags --max-count=1)`
		) && \. "$NVM_DIR/nvm.sh"
  fi

  if [ ! -f "$NVM_DIR/nvm.sh" ]; then
      printf "$red\n" "Failed ✗";
      exit;
  fi

  printf "$green\n" "Ok ✓";
}

function install_node {
  printf "Installing Node.js... "

  if [ ! -f "$HOME/.nvm/nvm.sh" ]; then
      printf "$red\n" "Failed (nvm not installed) ✗";
      exit;
  fi

  if [ ! which node > /dev/null 2>&1 ]; then
      source "$NVM_DIR/nvm.sh"
      nvm install node
  fi

  if [ ! which node > /dev/null 2>&1 ]; then
      printf "$red\n" "Failed ✗";
      exit;
  fi

  printf "$green\n" "Ok ✓";
}
