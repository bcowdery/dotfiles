#!/bin/bash

function install_brewfile() {
  printf "Installing Brewfile... $yellow\n" "Working •"

  brew update
  brew bundle
  brew cleanup
}
