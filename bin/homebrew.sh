#!/bin/bash

function install_homebrew() {
  printf "Installing Homebrew... "

  if [ ! -x /usr/local/bin/brew ]; then
      /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
  fi

  if [ ! -x /usr/local/bin/brew ]; then
      printf "$red\n" "Failed ✗";
      exit;
  fi

  printf "$green\n" "Ok ✓"
}
