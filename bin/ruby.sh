#!/bin/bash

function install_ruby() {
  printf "Installing Ruby... "

  if [ ! -x /usr/bin/ruby ]; then
    curl -sSL https://get.rvm.io | bash -s stable --ruby
    source $HOME/.rvm/scripts/rvm
  fi

  if [ ! -x /usr/bin/ruby ]; then
      printf "$red\n" "Failed ✗";
      exit;
  fi

  printf "$green\n" "Ok ✓";
}
