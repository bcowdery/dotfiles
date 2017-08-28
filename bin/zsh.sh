#!/bin/bash

function configure_zsh() {
  printf "Setting ZSH as default shell... "

  if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
    printf "\n"
    echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
    chsh -s /usr/local/bin/zsh;
  else
    printf "$green\n" "Ok ✓"
  fi;

  source ~/.zshrc;
}

function install_ohmyzsh() {
    printf "Installing Oh My Zsh... "

    if [ ! -d ~/.oh-my-zsh ]; then
      sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    fi

    if [ ! -f ~/.oh-my-zsh/oh-my-zsh.sh ]; then
        printf "$red\n" "Failed ✗";
        exit;
    fi

    printf "$green\n" "Ok ✓"
}
