Dotfiles
========

Common dotfiles and [Homebrew](https://brew.sh/) setups scripts for configuring my macOS development environment.

# Installation

## Using Git and the setup scripts

You can clone the repository wherever you want, although `~/.dotfiles` is preferred. The bootstrapper setup script will pull in the latest versions and copy the files to your home folder.

```
git clone https://github.com/bcowdery/dotfiles.git ~/.dotfiles && cd ~/.dotfiles && ./bin/setup.sh
```

To update, `cd` into your local `./dotfiles` repository and run
```
./bin/setup.sh
```

## Git-free install

To install these dotfiles without Git:

```
cd; curl -#L https://github.com/bcowdery/dotfiles/tarball/master | tar -xzv --strip-components 1
```
