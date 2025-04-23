#!/usr/bin/env bash

function rsync_dotfiles() {
	rsync --exclude "bin/" \
	  --exclude "init/" \
	  --exclude ".git/" \
		--exclude ".gitignore" \
		--exclude "Brewfile" \
		--exclude "macos.sh" \
		--exclude "bootstrap.sh" \
		--exclude "Readme.md" \
		-avh --no-perms --quiet . ~;
}

function update_dotfiles() {
  printf "$yellow\n" "Copying dotfiles to home directory... "

  if [ "$1" == "--force" -o "$1" == "-f" ]; then
  	rsync_dotfiles;

  else
    echo "This will overwrite existing files in your home directory "
    read -p "Are you sure? (y/n) " yn;

    case $yn in
      [Yy]* ) rsync_dotfiles;;
      * ) printf "Skiping dotfiles.\n\n"
    esac
  fi;

	printf "$green\n" "Done ✓"
	printf "$green\n\n" "Reload your shell or source ~/.zshrc to apply changes."
}
