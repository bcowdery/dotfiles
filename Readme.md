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


# Iterm2

## Color Themes

iTerm2 has better color fidelity than the built in Terminal, so your themes will look better.

Get the iTerm color settings

- [Tomorrow-Night](https://github.com/mbadolato/iTerm2-Color-Schemes/raw/master/schemes/Tomorrow%20Night.itermcolors)
- [More themes @ iterm2colorschemes](http://iterm2colorschemes.com/)

Just save it somewhere and open the file(s). The color settings will be imported into iTerm2. Apply them in iTerm through iTerm → preferences → profiles → colors → load presets. You can create a different profile other than `Default` if you wish to do so.

## Install a patched font

My Brewfile installs Source Code Pro and a patched variant that plays nice with powerline consoles. Other fonts can
be installed with the Homebrew-Font's cask or by from the powerline fonts repo. Homebrew is preferred as it will allow
you to script out the install in your `Brewfile`.

- [Homebrew-Fonts](https://github.com/caskroom/homebrew-fonts)
- [Others @ powerline fonts](https://github.com/powerline/fonts)

Set this font in iTerm2 (iTerm → Preferences → Profiles → Text → Change Font).

Restart iTerm2 for all changes to take effect.
