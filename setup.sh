#!/bin/bash
cd "$(dirname "${BASH_SOURCE}")";

# Get latest
git pull origin master;

# Check if ruby is installed
if [ -x /usr/bin/ruby ];
then
  echo "Skipping install of ruby. It is already installed"
else
  echo "Installing RVM and the latest stable version of ruby ..."
  curl -sSL https://get.rvm.io | bash -s stable --ruby
  source $HOME/.rvm/scripts/rvm

  if [ -x /usr/bin/ruby ];
  then
      echo "Succeeded installing ruby.";
  else
      echo "Failed to install ruby";
      exit;
  fi
fi

# Check if brew exists and is executable
if [ -x /usr/local/bin/brew ];
then
    echo "Skipping install of brew. It is already installed.";
    brew update;
    brew tap caskroom/cask;

else
    echo "Installing brew ...";
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)";
    if [ -x /usr/local/bin/brew ];
    then
        echo "Succeeded installing brew.";
    else
        echo "Failed to install brew";
        exit;
    fi
fi

# Install Brefile
brew bundle

# Set ZSH as the default shell
if ! fgrep -q '/usr/local/bin/zsh' /etc/shells; then
  echo '/usr/local/bin/zsh' | sudo tee -a /etc/shells;
  chsh -s /usr/local/bin/zsh;
fi;

# Copy dotfiles to $HOME
function applyDotfiles() {
	rsync --exclude ".git/" \
		--exclude "setup.sh" \
		--exclude "Readme.md" \
		-avh --no-perms . ~;
	source ~/.bash_profile;
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	applyDotfiles;
else
	read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
	echo "";
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		applyDotfiles;
	fi;
fi;

unset applyDotfiles;
