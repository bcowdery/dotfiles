#!/bin/bash

function install_brewfile() {
  printf "Installing Brewfile... $yellow\n" "Working •"

  brew update
  brew tap caskroom/cask
  brew bundle
  brew cleanup
}
