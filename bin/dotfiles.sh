#!/bin/bash

function rsync_dotfiles() {
	rsync --exclude "bin/" \
	  --exclude ".git/" \
		--exclude "setup.sh" \
		--exclude "Readme.md" \
		-avh --no-perms --quiet . ~;
	source ~/.bash_profile;
}

function configure_dotfiles() {
  printf "Copying dotfiles to home directory..."

  if [ "$1" == "--force" -o "$1" == "-f" ]; then
  	rsync_dotfiles;
    printf "$green\n" "Ok ✓"

  else
    printf "$yellow\n" "Working •"
    printf "$yellow\n" "This will overwrite existing files in your home directory "
    read -p "Are you sure? (y/n) " yn;

    case $yn in
      [Yy]* ) rsync_dotfiles;;
      * ) printf "Skiping dotfiles.\n"
    esac
  fi;

  printf "$green\n" "Done."
}
