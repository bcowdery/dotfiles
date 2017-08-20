#!/bin/bash
red='\e[1;31m%s\e[0m'
green='\e[1;32m%s\e[0m'
yellow='\e[1;33m%s\e[0m'

# Get latest dotfiles
cd "$(dirname "${BASH_SOURCE}")"
git pull origin master &> /dev/null

# Check if ruby exists and is executable
printf "Installing Ruby... "

if [ ! -x /usr/bin/ruby ]; then
  curl -sSL https://get.rvm.io | bash -s stable --ruby
  source $HOME/.rvm/scripts/rvm
fi

if [ -x /usr/bin/ruby ]; then
    printf "$green\n" "Ok";
else
    printf "$red\n" "Failed";
    exit;
fi

# Check if brew exists and is executable
printf "Installing Homebrew... "

if [ ! -x /usr/local/bin/brew ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
fi

if [ -x /usr/local/bin/brew ]; then
    printf "$green\n" "Ok";
else
    printf "$red\n" "Failed";
    exit;
fi

# Install Brefile
printf "Installing Brewfile... "
printf "$yellow\n" "Working"

brew update
brew tap caskroom/cask
brew bundle

# Set ZSH as the default shell
printf "Setting ZSH as default shell... "

if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
  printf "\n"
  echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/zsh;
else
  printf "$green\n" "Ok"
fi;

# Copy dotfiles to $HOME
printf "Copying dotfiles to home directory..."

function dotfiles() {
	rsync --exclude ".git/" \
		--exclude "setup.sh" \
		--exclude "Readme.md" \
		-avh --no-perms --quiet . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	dotfiles;
  printf "$green\n" "Ok"

else
  printf "\n"
  printf "$yellow\n" "This will overwrite existing files in your home directory "
  read -p "Are you sure? (y/n) " yn;

  case $yn in
    [Yy]* ) dotfiles;;
    * ) printf "Skiping dotfiles.\n"
  esac
fi;

printf "$green\n" "Done."
unset dotfiles
