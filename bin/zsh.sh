#!/bin/bash

function configure_zsh() {
  # Set ZSH as the default shell
  printf "Setting ZSH as default shell... "

  if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
    printf "\n"
    echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
    chsh -s /usr/local/bin/zsh;
  else
    printf "$green\n" "Ok ✓"
  fi;
}
