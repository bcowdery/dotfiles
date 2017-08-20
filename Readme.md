Dotfiles
========

My .dotfiles, configurations and unattented software installs for macOS.

* Installs [RVM](https://rvm.io)
* Installs [Homebrew](https://brew.sh/)
* Installs [Homebrew-Cask](https://caskroom.github.io)
* Installs all software in [Brewfile](Brewfile)
* Sets ZSH to the shell default
* Copies dotfiles to the user $HOME


# Installation

You can clone the repository wherever you want, although `~/.dotfiles` is preferred. The [setup](setup.sh) script will pull in the latest version, install all the software and copy dotfiles to their new $HOME.

```
git clone https://github.com/bcowdery/dotfiles.git ~.dotfiles && ./dotfiles/setup.sh
```

## Updating

You can update your installation at any time by running the setup script agian. It will automatically pull the latest sources from git and invoke Homebrew to update software and install new packages.

```
~/.dotfiles/setup.sh
```
