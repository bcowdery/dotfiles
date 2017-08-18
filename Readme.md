Dotfiles
========

* [Homebrew](https://brew.sh/)
* [Homebrew-Cask](https://caskroom.github.io/)

# Install RVM (Ruby Version Manager)

Install the latest stable version of ruby using RVM. RVM allows you to easily
install, mange and work with multiple versions of ruby. Ruby is required to run
Homebrew so we'll need to get that out of the way first.

```
$ curl -sSL https://get.rvm.io | bash -s stable --ruby
```

# Install Homebrew & Cask

Install the homebrew package manager for macOS, and the Homebrew-Cask extensions for
community applications installers and large binary packages.

```
$ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
```
$ brew install caskroom/cask/brew-cask
```

## Brewfile Install
```
$ brew bundle
```

## Oh My zsh
```
curl -L http://install.ohmyz.sh | sh
```
