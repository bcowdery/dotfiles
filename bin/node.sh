#!/bin/bash

function install_nvm() {
  printf "Installing NVM... "

  if [ ! -f "$HOME/.nvm/nvm.sh" ]; then
    curl -sSL https://raw.githubusercontent.com/creationix/nvm/v0.33.8/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    source "$NVM_DIR/nvm.sh" && \. "$NVM_DIR/nvm.sh"
    source "$NVM_DIR/bash_completion" && \. "$NVM_DIR/bash_completion"
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
